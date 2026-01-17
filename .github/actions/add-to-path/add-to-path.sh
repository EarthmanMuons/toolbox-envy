#!/usr/bin/env bash
set -euo pipefail

die() {
	printf "ERROR: %s\n" "$*" >&2
	exit 2
}
info() { printf "INFO: %s\n" "$*" >&2; }

include_bins_raw=""
project_bin=""
write_summary="true"

while (($#)); do
	case "$1" in
	--include-bins)
		include_bins_raw="${2-}"
		shift 2
		;;
	--project-bin)
		project_bin="${2-}"
		shift 2
		;;
	--write-summary)
		write_summary="${2-}"
		shift 2
		;;
	*) die "unknown argument: $1" ;;
	esac
done

[[ -n $include_bins_raw ]] || die "--include-bins is required"

case "$write_summary" in
true | false) ;;
*) die "write_summary must be true or false (got: $write_summary)" ;;
esac

ws="${GITHUB_WORKSPACE:-$PWD}"

action_path="${GITHUB_ACTION_PATH:-}"
[[ -n $action_path ]] || die "GITHUB_ACTION_PATH is not set (this must run as a GitHub Action)"
toolbox_root="$(cd "$action_path/../../.." && pwd -P)"

# Normalize list: comma or newline separated, trimmed.
mapfile -t bins < <(printf "%s\n" "$include_bins_raw" |
	tr ',' '\n' |
	sed 's/^[[:space:]]*//; s/[[:space:]]*$//' |
	sed '/^$/d')

((${#bins[@]})) || die "--include-bins produced an empty list"

added=()

add_path_dir() {
	local dir="$1"
	for a in "${added[@]-}"; do
		[[ $a == "$dir" ]] && return 0
	done
	echo "$dir" >>"${GITHUB_PATH:?}"
	added+=("$dir")
}

# Optional project_bin: if provided, it must exist.
if [[ -n $project_bin ]]; then
	if [[ $project_bin != /* ]]; then
		project_bin="${ws}/${project_bin}"
	fi
	[[ -d $project_bin ]] || die "project_bin does not exist or is not a directory: $project_bin"
	add_path_dir "$project_bin"
fi

missing=()
invalid=()

for name in "${bins[@]}"; do
	# Keep names boring and safe.
	if [[ ! $name =~ ^[a-z0-9][a-z0-9_-]*$ ]]; then
		invalid+=("$name")
		continue
	fi

	dir="${toolbox_root}/bin/${name}"
	if [[ -d $dir ]]; then
		add_path_dir "$dir"
	else
		missing+=("$name")
	fi
done

if ((${#invalid[@]})); then
	{
		printf "Invalid include_bins entries:\n"
		for n in "${invalid[@]}"; do
			printf "  - %s\n" "$n"
		done
	} >&2
	exit 2
fi

if ((${#missing[@]})); then
	{
		printf "Missing bin/* directories in toolbox-envy:\n"
		for n in "${missing[@]}"; do
			printf "  - bin/%s\n" "$n"
		done
	} >&2
	exit 2
fi

if [[ $write_summary == "true" && -n ${GITHUB_STEP_SUMMARY:-} ]]; then
	{
		echo "### toolbox-envy PATH setup"
		echo
		echo "**Toolbox root:** \`$toolbox_root\`"
		echo
		if ((${#added[@]})); then
			echo "**Added to PATH (in precedence order):**"
			for d in "${added[@]}"; do
				echo "- \`$d\`"
			done
		else
			echo "**Added to PATH:** (none)"
		fi
		echo
	} >>"$GITHUB_STEP_SUMMARY"
fi

info "toolbox-envy add-to-path complete"
