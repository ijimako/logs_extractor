# Logs extractor

A script to help you search for string(s) (case sensitive or not) in file(s) (on host(s) or not) in a flexible way.
Script is not only for logs search. Can be used for something else.

### Usage
``./logs-extractor.sh -f <file_path> -s <string> [-S <string_case_sensitive_ignore>] [-h <host>]``

**Good to know:** Multiple -h accepted. Multiple -s and/or -S accepted will make search act like an AND operator.

### Search behaviour
Behaviour for combining search of multiple strings:
* OR --> use ``-s "string1\|string2"`` will make search act like an OR
* AND --> use ``-s "string1" -s "string2"`` will make the search act like an AND
You can also combine OR and AND for complexe strings search.

### Remote searching
You can also search strings in files on one or multiple remote host (for example on your servers).
The script will automatically use SSH.

ex: use ``-h prod1@prod1.com`` for one host
ex2: use ``-h prod1@prod1.com -h prod2@prod2.com`` for multiple hosts

### Local searching
If you don't specify any host (-h option) the search will act locally.


### Full example

``./logs-extractor.sh -f /var/logs/*.log* -s "2019" -S "John Doe" -h prod1@prod1.com``
