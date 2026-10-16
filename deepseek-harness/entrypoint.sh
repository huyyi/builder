#!/usr/bin/env bash
set -euo pipefail

ENABLE_SSH="${ENABLE_SSH:-true}"
DSH_SSH_PORT="${DSH_SSH_PORT:-2222}"

start_sshd() {
  mkdir -p /run/sshd /home/dsh/.ssh
  chmod 700 /home/dsh/.ssh
  chown dsh:dsh /home/dsh/.ssh

  if [[ -n "${DSH_SSH_AUTHORIZED_KEYS:-}" ]]; then
    printf '%s\n' "$DSH_SSH_AUTHORIZED_KEYS" > /home/dsh/.ssh/authorized_keys
    chown dsh:dsh /home/dsh/.ssh/authorized_keys
    chmod 600 /home/dsh/.ssh/authorized_keys
  fi

  local password_auth=no
  if [[ -n "${DSH_SSH_PASSWORD:-}" ]]; then
    echo "dsh:${DSH_SSH_PASSWORD}" | chpasswd
    password_auth=yes
  fi

  ssh-keygen -A >/dev/null 2>&1
  /usr/sbin/sshd -D -e \
    -p "$DSH_SSH_PORT" \
    -o PermitRootLogin=no \
    -o UsePAM=no \
    -o KbdInteractiveAuthentication=no \
    -o PubkeyAuthentication=yes \
    -o PasswordAuthentication="$password_auth" \
    -o AllowUsers=dsh &
}

case "${ENABLE_SSH,,}" in
  1|true|yes|on)
    start_sshd
    ;;
  *)
    ;;
esac

exec runuser -u dsh -- /usr/local/bin/dsh-stack "$@"
