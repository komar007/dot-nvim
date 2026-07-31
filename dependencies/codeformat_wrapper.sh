#!/usr/bin/env bash

detect_config=false
args=()
config_args=()
file=

while (($# > 0)); do
	arg="$1"
	shift

	case "$arg" in
	--detect-config | -d)
		detect_config=true
		;;
	--file | -f)
		if (($# > 0)); then
			file="$1"
			args+=("$arg" "$file")
			shift
		else
			args+=("$arg")
		fi
		;;
	--file=*)
		file="${arg#--file=}"
		args+=("$arg")
		;;
	*)
		args+=("$arg")
		;;
	esac
done

if [[ "$detect_config" == true && -n "$file" ]]; then
	pwd=$PWD
	if [[ "$file" != /* ]]; then
		file="$pwd/$file"
	fi
	directory=$(dirname "$file")

	while true; do
		config="$directory/.editorconfig"
		if [[ -f "$config" ]]; then
			config_args=(--config "$config")
			break
		fi

		[[ "$directory" == "$pwd" || "$directory" == / ]] && break
		directory=$(dirname "$directory")
	done
fi

exec CodeFormat "${args[@]}" "${config_args[@]}"
