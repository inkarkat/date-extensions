#!/usr/bin/env bats

load fixture

@test "diff and addendum with output formats" {
    local -r inputDate='1976-10-20'
    typeset -A data=(
	[seconds]='-1562058000'
	[minutes]='-26034300'
	[hours]='-433905'
	[days]='-18079'
	[weeks]='-2583'
	[months]='-602'
	[years]='-49'
	[generations]='-2'
	[original]="$inputDate"
	[whole-units]='2583 weeks = 602.6 months = 49.5 years = 2 generations ago'
	[smallest-unit]='2583 weeks ago'
	[best-unit]='2 generations ago'
	[largest-unit]='2 generations ago'
	[textform]='[2583 weeks ago|602.6 months ago|49.5 years ago|2 generations ago|1g 19y 6mo 4d 14h 24m ago|2583 weeks = 602.6 months = 49.5 years = 2 generations ago]'
    )

    for outputFormat in "${!data[@]}"
    do
	run -0 datediff --output "$outputFormat" --file - <<<"$inputDate"$'\twith\ttext' \
	    && assert_output "${data["$outputFormat"]}"$'\twith\ttext' \
	    || fail "$ --output outputFormat"

	run -0 datediff --prefix '(' --suffix ')' --output "$outputFormat" --file - <<<"$inputDate"$'\twith\ttext' \
	    && assert_output "(${data["$outputFormat"]})"$'\twith\ttext' \
	    || fail "--prefix '(' --suffix ')' --output $outputFormat"
    done
}
