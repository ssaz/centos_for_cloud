centos_for_cloud
==========

Docker Images of CentOS-7 7.3.1611 x86_64;

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
ssh user: XXXXXXXX
ssh user password: XXXXXXXXXXXXXXXX
ssh secure password change every 30 minutes [enabled]
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
```

docker log print new password when password changed by period.
```
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
ssh user new password: XXXXXXXXXXXXXXXX
----- ----- ----- ----- -----
----- ----- ----- ----- -----
----- ----- ----- ----- -----
```

## Example custom username

```
docker run -e 'DOCKER_SSH_USER=custom_username' -d -p 2222:22 centos_for_cloud
```

## Example custom username and password

```
docker run -e 'DOCKER_SSH_USER=custom_username' \
-e 'DOCKER_SSH_PASSWORD=custom_password' \
-d -p 2222:22 centos_for_cloud
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
docker run -e 'DOCKER_SSH_SECURE_CHPWD_DISABLED=false' \
-e 'DOCKER_SSH_SECURE_CHPWD_PERIOD=60' \
-e 'DOCKER_SSH_USER=custom_username' \
-e 'DOCKER_SSH_PASSWORD=custom_password' \
-d -p 2222:22 centos_for_cloud | cut -c 1-12 | xargs docker logs -f
```

-END-
