#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

. tty-logger-init.bash

install -d "$_tty_logger_directory"
{
if [[ -e $_default_tty_log_filename ]]
then exec 3> "$_default_tty_log_filename.$(($(
    _generate_tty_logs_filename_version|sort -nr|head -n1) + 1))"
else exec 3> "$_default_tty_log_filename"
fi
} 4> "$_tty_logger_directory/.lock"
_date_format='+%Y-%m-%dT%H:%M:%S%:z'

_format () {
    while IFS= read -r x
    do printf "%s %s%s%s\n" "$(date "$_date_format")" "$1" "$x" "$2"
    done
}

date "$_date_format" >&3
echo "$@" >&3
{ { { { { {
    "$@"|tee /dev/stderr 2>&4
} 2>&1 >&6|tee /dev/stderr 2>&5
} >&7
} 6>&1|_format >&3
} 7>&1|_format '[1;41m' '[0m' >&3
} 4>&1
} 5>&2
