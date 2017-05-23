centos_for_cloud
==========

Docker Images of CentOS-6 6.8 x86_64;

Support sshd, sudo, supervisor;

Automatically create a random username and password for ssh;

Support custom username and password;

Support Change password period or not;

Dont support public key authentication or google authentication yet;

DockerHub: https://hub.docker.com/r/ssorg/centos_for_cloud/

Github: https://github.com/ssaz/centos_for_cloud

## Example (Best Practice)

```
docker run -d -p 2222:22 centos_for_cloud | cut -c 1-12 | xargs docker logs -f
```

then docker log print username and password, and password change policy.
```
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
ssh user: *** (created by env)
ssh user password: *** (created by env)
ssh secure password change every 1 minutes [disabled]
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
/usr/lib/python2.6/site-packages/supervisor-3.3.1-py2.6.egg/supervisor/options.py:298: UserWarning: Supervisord is running as root and it is searching for its configuration file in default locations (including its current working directory); you probably want to specify a "-c" argument specifying an absolute path to a configuration file for improved security.
  'Supervisord is running as root and it is searching '
DATE CRIT Supervisor running as root (no user in config file)
DATE INFO supervisord started with pid 26
DATE INFO spawned: 'supervisor_stdout' with pid 29
DATE INFO spawned: 'sshd' with pid 30
DATE INFO spawned: 'chpwd' with pid 31
DATE INFO success: supervisor_stdout entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
DATE INFO success: sshd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
DATE INFO success: chpwd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

docker log print new password when password changed by period.
```
chpwd stdout | 
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
ssh user new password: XXXXXXXXXXXXXXXX
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
DATE INFO exited: chpwd (exit status 255; not expected)
DATE INFO spawned: 'chpwd' with pid 42
DATE INFO success: chpwd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

## Example custom username

```
docker run -e 'DOCKER_SSH_USER=custom_username' -d -p 2222:22 centos_for_cloud
```

## Example custom username and password

```
docker run -e 'DOCKER_SSH_USER=custom_username' -e 'DOCKER_SSH_PASSWORD=custom_password' -d -p 2222:22 centos_for_cloud
```

## Example Disable change password automatic, default false

```
docker run -e 'DOCKER_SSH_SECURE_CHPWD_DISABLED=true' -d -p 2222:22 centos_for_cloud
```

## Example Set change password period(minutes) for automatic, default 30

```
docker run -e 'DOCKER_SSH_SECURE_CHPWD_PERIOD=60' -d -p 2222:22 centos_for_cloud
```

## Example Full params

```
docker run -e 'DOCKER_SSH_SECURE_CHPWD_DISABLED=false' -e 'DOCKER_SSH_SECURE_CHPWD_PERIOD=60' -e 'DOCKER_SSH_USER=custom_username' -e 'DOCKER_SSH_PASSWORD=custom_password' -d -p 2222:22 centos_for_cloud | cut -c 1-12 | xargs docker logs -f
```

-END-
