# Flux Compose Cluster

> 🐧️ I have greatly been enjoying my time using Flux!

This workflow includes:

1. A Flux container defined in the [Dockerfile](Dockerfile) with Spindle.

 
## Usage

### 1. Build

You can first build the images (used for workers and broker):

```bash
docker compose build
```

Note this will trigger three builds, so be careful! If you want to build just once,
you can build the [replicas example](../replicas) example first that will derive the same
layers (and they will then be reused).

### 2. Start Cluster

Then bring them up! You'll see the rabbit image pull if you don't have it already. 
Since we are starting a cluster, it's recommended to start in detached mode:

```bash
docker compose up -d
```

You can then see containers running:

```bash
docker compose ps
```
```console
NAME                COMMAND                  SERVICE             STATUS              PORTS
basic-node-1        "/bin/sh -c '/bin/ba…"   node                running             
basic-node-2        "/bin/sh -c '/bin/ba…"   node                running             
basic-node-3        "/bin/sh -c '/bin/ba…"   node                running             
basic-node-4        "/bin/sh -c '/bin/ba…"   node                running             
rabbitmq            "docker-entrypoint.s…"   rabbit              running             4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp
```

Since we have defined the containers separately, to look at logs we can target any individual one:

```bash
docker compose logs node-1
docker compose logs node-2
docker compose logs node-3
docker compose logs node-4
```

Add an `-f` to keep the log open.
Now you can shell in to interact with your cluster (shelling into the main broker below):

```bash
docker exec -it node-1 bash
```

And flux should be up and running - you can submit jobs, etc.

```bash
 fluxuser@a414059fd5a8:~$ flux resource list
     STATE NNODES   NCORES    NGPUS NODELIST
      free      4        4        0 node-[1-4]
 allocated      0        0        0 
      down      0        0        0 

$ flux overlay status
0 basic-node-1: full
├─ 1 node-2: full
├─ 2 node-3: full
└─ 3 node-4: full
```

Let's demonstrate that Spindle works:

```bash
cd /shared
export SPINDLE_DEBUG=2
flux run -o userrc=/home/fluxuser/Spindle-inst/etc/spindle/spindle.rc -o spindle -n4 hostname
```
```console
node-1
node-4
node-3
node-2
```

Now check the directory for the debug output. If Spindle worked, there should be four files, one for each node:
```bash
ls -l
```
```console
total 108
-rw-r----- 1 fluxuser fluxuser 30164 Aug 20 23:56 spindle_output.node-1.132
-rw-r----- 1 fluxuser fluxuser 22748 Aug 20 23:56 spindle_output.node-2.70
-rw-r----- 1 fluxuser fluxuser 26690 Aug 20 23:56 spindle_output.node-3.70
-rw-r----- 1 fluxuser fluxuser 23539 Aug 20 23:56 spindle_output.node-4.75

```

It worked!

### 3. Clean up

Make sure to stop and remove containers!

```bash
docker compose stop
docker compose rm
```

## Developer

### Changes for Compose

You might want to use the setup here as an example of how to configure a cluster,
and while some of it is OK, this is an overly simplified version and you should
generally consult the [Flux docs](https://flux-framework.readthedocs.io/en/latest/adminguide.html)
admin guide. However, there are some tweaks we do here _just_ for docker-compose you should know about!

1. We need to tell the broker.toml to load the `noverify` plugin under the `resource` directive.  The reason we have to do this is because docker compose provides hostnames as the container identifiers, and Flux checks this against the resources defined. By adding `noverify` we skip this check.
checks this against the resources defined. By adding `noverify` we skip this check.
2. We derive and export `FLUX_FAKE_HOSTNAME` to coincide with the name provided by docker so the hosts register.

This is a fairly new setup, so please let us know if you run into issues.

### Customization

You generally will want to install your software of choice into the [Dockerfile](Dockerfile),
add any additional services needed, and then shell inside to interact with Flux and test your scripts!
If you need to add volumes, that can work too.

#### 1. Changing workers

To change the number of workers, since assets need to be built that require sudo (during build)
we require setting workers. You can change this in the header of the [docker-compose.yml](docker-compose.yml)

```yaml
# Shared number of replicas (workers) for build and runtime
# This does not include the broker
x-shared-workers
  &workers
  replicas: 3
```


Note that we used "deploy -> replicas" to scale the workers. This means we currently don't have nice
control of hostname, so it defaults to "directory-container" which is `basic-node-<number>`.
docker-compose is a monster and starts counting at 1, so generally `basic-node-1` is the broker,
and `basic-node-N` is in reference to a worker.

#### 2. Changing directory location

Docker compose derives the hostname from the directory, so if you move the directory you'll need to tweak
a few places:

1. The `flux R encode` command in the [Dockerfile](Dockerfile)
2. The reference to hosts in the [broker.toml](flux/broker.toml)
3. The reference for the mainHost (that populates the entrypoint) in the [docker-compose.yml](docker-compose.yml)

It also doesn't hurt to do a grep for "basic" if you think you missed one!

