This is a repo for demoing Chaos engineering using a basic Wordpress install.

## Setup

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

Create a Kubernetes secret with your [Datadog API Key](https://app.datadoghq.com/account/settings#api).

```
kubectl create secret generic datadog-api --from-literal=token=<YOUR_DATADOG_API_KEY>
```

Apply the YAML files.

```
kubectl apply -f kubernetes
```

---

## Setup Wordpress

Launch a browser with Wordpress:

```
minikube service wordpress
```

This will take you to a Wordpress setup page where you can create the admin user and log in. Once you log in, update the homepage to show an interesting/funny image and greet the conference attendees.

If you need to edit the site later, the url will be at /wp-login and you can use the credentials you set on the first visit.

## Setup Datadog Monitoring

Get a bash shell on the running MySQL pod:

```
kubectl exec -ti $(kubectl get po --selector=tier=mysql -o jsonpath='{.items[0].metadata.name}') -- /bin/bash
```

Then run the following to setup the Datadog user and grant it access to collect metrics.

```
mysql --user=root --password=my-password -e "CREATE USER 'datadog'@'%' IDENTIFIED BY 'mypassword';"
mysql --user=root --password=my-password -e "GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'%' WITH MAX_USER_CONNECTIONS 5;"
mysql --user=root --password=my-password -e "GRANT PROCESS ON *.* TO 'datadog'@'%';"
mysql --user=root --password=my-password -e "GRANT SELECT ON performance_schema.* TO 'datadog'@'%';"
```

Log out of the MySQL pod and apply the Datadog yaml.

## Before steps

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
