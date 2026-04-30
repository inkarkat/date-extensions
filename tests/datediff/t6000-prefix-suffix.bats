#!/usr/bin/env bats

load fixture

@test "just a prefix" {
    run -0 datediff --prefix 'result: ' --output seconds 1976-10-20
    assert_output 'result: -1562058000'
}

@test "just a suffix" {
    run -0 datediff --suffix ' seconds measured' --output seconds 1976-10-20
    assert_output '-1562058000 seconds measured'
}

@test "diff with prefixed and suffixed output" {
    prefix='delta('
    suffix=') detected'
    while IFS=$'\t' read -r outputFormat expectedOutput
    do
	run -0 datediff --prefix "$prefix" --suffix "$suffix" --output "$outputFormat" 1976-10-20 \
	    && assert_output "$expectedOutput" \
	    || fail "--output ${outputFormat@Q} --prefix ${prefix@Q} --suffix ${suffix@Q}"
    done <<-EOF
seconds	delta(-1562058000) detected
minutes	delta(-26034300) detected
hours	delta(-433905) detected
days	delta(-18079) detected
weeks	delta(-2583) detected
months	delta(-602) detected
years	delta(-49) detected
generations	delta(-2) detected
whole-units	delta(2583 weeks = 602.6 months = 49.5 years = 2 generations ago) detected
smallest-unit	delta(2583 weeks ago) detected
largest-unit	delta(2 generations ago) detected
textform	delta([2583 weeks ago|602.6 months ago|49.5 years ago|2 generations ago|2583 weeks = 602.6 months = 49.5 years = 2 generations ago]) detected
EOF
}

@test "no prefix / suffix when comparison succeeds" {
    run -0 datediff --output best-unit -eq 1s "2026-04-20 10:00:01"
    assert_output ''
}

@test "multiple prefixes and suffixes are added in order" {
    run -0 datediff --prefix 'result' --prefix ': ' --suffix ' ' --suffix 'seconds' --suffix ' measured' --suffix '.'  --output seconds 1976-10-20
    assert_output 'result: -1562058000 seconds measured.'
}
