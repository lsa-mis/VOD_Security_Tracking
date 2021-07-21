# VOD_Security_Tracking

<!-- <p align="center"><img width=12.5% src="https://github.com/anfederico/Clairvoyant/blob/master/media/Logo.png"></p>
<p align="center"><img width=60% src="https://github.com/anfederico/Clairvoyant/blob/master/media/Clairvoyant.png"></p> -->

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![Ruby](https://img.shields.io/badge/ruby-3.0.1-red)
[![Build Status](https://travis-ci.org/anfederico/Clairvoyant.svg?branch=master)](https://travis-ci.org/anfederico/Clairvoyant)
![Dependencies](https://img.shields.io/badge/dependencies-up%20to%20date-brightgreen.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A way to track resources or systems involving sensitive data. Increase the ability to monitor, track and act on items that are in the scope of this project. System reports will be available to support the goal of providing a secure computing environment. 



## Getting Started

These instructions will get a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to run this containerized application.
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Git](https://github.com/git-guides/install-git)

### Installing

* clone the repo 

```
git clone git@github.com:lsa-mis/VOD_Security_Tracking.git
```

* navigate to the local instance and build the application initially

```
cd VOD_Security_Tracking && docker-compose build app
```
---

* To start the container's bash shell _(this will leave you in `/home/app#` prompting for a command)_

```
docker-compose run --rm --service-ports app bash
```

* If you have not previously created and migrated the database || if you ```docker system prune -a``` || if you ```docker volume prune``` then in the shell run 

```
/home/app# bin/rails db:setup
``` 

* or if the tables existed you would run

```
/home/app# bin/rails db:reset
```

* to test the application initially you can run the server

```
/home/app# bin/rails s -b 0.0.0.0
```

* Ctrl-C to stop the application execution then type exit to exit the shell

---

* stop the container and associated containers with their networks 

```
docker-compose down
```

* to run the full application with all the containers the application depends on

```
docker-compose up
```

* Open the application by pointing your browser to localhost:3000
* if you want to log into the _Admin Dashboard_ use the credentials 
    * Userid: *admin@example.com* Pwd: *password* _(this should be changed immediately)_

## Running the tests

This application uses RSpec to manage and run the automated test. to run the fullsuite:

```
docker-compose run --rm --service-ports app bash
```

```sh
cd /home/app bundle exec rspec 
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Ruby](http://www.ruby.org) - The web framework used
* [Rails](https://www.rails.org/) - Dependency Management

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us. 

## Developers/Designers/JIRA Managers: 
[eMail address](security-track-devs@umich.edu)

Rick Smoke - project’s lead & developer, Rita Barvinok - developer, Ananta Saple - developer,  Dave Chmura - developer,
Maria Laitin - UI designer, Jessica Santos Kowalewski - JIRA manager, QA testing 



See also the list of [contributors](https://github.com/lsa-mis/VOD_Security_Tracking/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

---------------
## configurations
*set noscript support info

tailwindsCSS is in compatablity mode. After things are updated across the ecosystem update the npm module https://tailwindcss.com/docs/installation#post-css-7-compatibility-build
