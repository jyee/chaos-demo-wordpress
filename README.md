This is a repo for demoing Chaos engineering using a basic Wordpress install.

## Setup Kubernetes

Install the necessary software on your Mac.

```
brew cask install virtualbox
brew cask install minikube
brew install kubernetes-cli
```

Start Minikube.

```
# Start minikube using a new profile
minikube start -p <conference-name>

# Set the profile as the default
minikube profile <conference-name>
```

Create Kubernetes secrets with your [Datadog API Key](https://app.datadoghq.com/account/settings#api) and your [Gremlin team ID, secret](https://app.gremlin.com/settings/team), and cluster name.

```
kubectl create secret generic datadog-api --from-literal=dd-api-key=<YOUR_DATADOG_API_KEY>
kubectl create secret generic gremlin-team-id --from-literal=gremlin-team-id=<YOUR_GREMLIN_TEAM_ID>
kubectl create secret generic gremlin-team-secret --from-literal=gremlin-team-secret=<YOUR_GREMLIN_TEAM_SECRET>
kubectl create secret generic gremlin-cluster-id --from-literal=gremlin-cluster-id=<YOUR_GREMLIN_CLUSTER_ID>
```

Apply the YAML files.

```
kubectl apply -f kubernetes
```

Note this may take quite a while to download container images on the first run.

Once the MySQL pod is running, run the `setup.sh` file to create a Datadog user. This will allow Datadog to pull metrics from MySQL.

## Setup Wordpress

Launch a browser with Wordpress:

```
minikube service wordpress
```

This will take you to a Wordpress setup page where you can create the admin user and log in. Once you log in, update the homepage to show an interesting/funny image and greet the conference attendees.

If you need to edit the site later, the url will be at /wp-login and you can use the credentials you set on the first visit.

## Setup the


Open the Gist
https://gist.github.com/jyee/a9c1d74d20ef40ff114fc6a1705780f4

## Run the experiment

Ensure there's traffic on the website:

```
while sleep 0.5; do curl http://<SERVICE URL>/; done
```

Then kill the MySQL pod:

```
kubectl get po
kubectl delete po <mysql pod>
```

That will respawn so quickly that we probably wont notice.

Delete the MySQL deployment

```
kubectl delete deploy mysql
```

Now what happens?

Take notes in the Gist

Ensure you get the alert. Talk about useful alerts, link to the mysql and kubernetes dashboards.
Restart Mysql

```
kubectl apply -f mysql-deployment.yaml
```

## After Steps

Update the Gist and save it.

So we're going to make the appropriate Jira tickets/Trello cards/whatever.
I'm going to make all of this available to you afterwards.
Also, We're definitely going to celebrate tonight!
