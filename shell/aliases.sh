#!/bin/sh source-this-script

# datei			International format 29-May-2015
alias datei='date +%d-%b-%Y'

# datetimei		International format 29-May-2015 14:46
alias datetimei='date "+%d-%b-%Y %T"'

# dates			Sortable format 2015-05-29
alias dates='date +%Y-%m-%d'

# datetimes		Sortable format 2015-05-29 14:46
alias datetimes='date "+%Y-%m-%d %T"'

# datee			Epoch format 1467031439; parse via date --date='@1467031439'
alias datee='date +%s'

# dateiso		ISO-8601 format 2015-05-29
alias dateiso='date --iso-8601'

# datetimeiso		ISO-8601 format 2015-05-29T14:46:00+02:00
alias datetimeiso='date --iso-8601=seconds'

# utcdatetime		UTC ISO-8601 format 2015-05-29T14:46:00+00:00
alias utcdatetime='utcdate --iso-8601=seconds'

# datetimeall		local and UTC ISO-8601 format and UTC Unix epoch
datetimeall()
{
    {
	date --iso-8601=seconds "$@" && \
	    utcdate --iso-8601=seconds "$@" | sed -e 's/+00:00/ UTC/' && \
	    utcdate +@%s "$@"
    } | joinBy - ' / '
}
