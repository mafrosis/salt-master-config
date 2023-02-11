Salt Master
==========

Config for running a Salt Master in docker, built on the fine work at
[`cdalvaro/docker-salt-master`](https://github.com/cdalvaro/docker-salt-master).


## How to Use

Notes to remind me how to use Salt with a master and minions:


### Add another minion

Ensure that the master is configured in the minion config:
```
master: locke
```

The new minion should show up with the following command.
```
> docker compose exec salt-master salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
rand
Proceed? [n/Y] Y
Key for minion rand accepted.
```

### View known minions
```
> docker compose exec salt-master salt-key -L
Accepted Keys:
caul
jorg
locke
ringil
Denied Keys:
Unaccepted Keys:
Rejected Keys:
```

### View minion grains
```
docker compose exec salt-master salt 'jorg' grains.items
```

### State apply

Apply a single state, `sshd`, so the host `locke`:
```
docker compose exec salt-master salt 'locke' state.apply sshd
```

## Debugging

Due to the async nature of Salt, and the complex configuration, errors are often non-obvious.

From the master, run a state apply including debug logging:
```
docker compose exec salt-master salt -l debug 'locke' state.apply
```

On the target host, you can tail the minion logs during `state.apply`, but this will show `INFO`
level information that you can see on the `salt-master` after the `state.apply`:
```
sudo tail -f /var/log/salt/minion
```

On the target host, try running the `salt-minion` in the foreground with debug logging:
```
sudo systemctl stop salt-minion
sudo /usr/bin/salt-minion -l debug
```

### View the salt-master config
```
docker compose exec salt-master cat /etc/salt/master
```


## 1Password Connect

A custom external pillar is submoduled from
[`mafrosis/1password-connect-config`](https://github.com/mafrosis/1password-connect-config).

For this to work you need to add following to `config/ext_pillar.conf`:
```
ext_pillar:
  - 1password:
      connect_host: http://example.com:8081
      connect_token: eyJhbGc .. snip .. 2YCkucw
      vault_id: b6hmle4xxxxxxxxxxxxy4lcwza
```

Test the external pillar is working with the following command, which connects from the current
host to the salt master to pull pillar data:
```
sudo salt-call pillar.data
```
