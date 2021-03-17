# README
```docker-compose up```

====================================

```docker-compose build app```

```docker-compose run --rm --service-ports app bash```

```rails s -b 0.0.0.0```


This is a demo app for showcasing a Rails 5 application running on docker-compose in development and Kubernetes on GKE in production.

Read Part I: Rails on docker-compose here.

Read Part II: Rails on Kubernetes here


---------------
*pulled repo
*run ```docker-compose build app```
*run ```docker-compose run --rm --service-ports app bash```
*in shell run ```bundle```
*in shell run ```bin/rails db:migrate```
*in shell run ```bin/rails s -b 0.0.0.0``` to test
*then exit shell
*run ```docker-compose down```
*run ```docker-compose up```

---------------

#configuartions
*set noscript support info


-----------
tailwindsCSS is in compatablity mode. After things are updated across the ecosystem update the npm module https://tailwindcss.com/docs/installation#post-css-7-compatibility-build


yarn install --frozen-lockfile