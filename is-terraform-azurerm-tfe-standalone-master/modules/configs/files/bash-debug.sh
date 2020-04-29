
# Adding helper aliases and functions for TFE debugging
alias tfe-logs='journalctl -xu cloud-final -o cat'
alias tfe-logs-follow='journalctl -xu cloud-final -o cat -f'
alias tfe-replicated='replicatedctl system status'
alias tfe-docker-containers="sudo docker ps --format 'table {{.Names}}\t{{.RunningFor}}\t{{.Status}} ago'"
alias tfe-docker-containers-all="sudo docker ps -a --format 'table {{.Names}}\t{{.RunningFor}}\t{{.Status}} ago'"
