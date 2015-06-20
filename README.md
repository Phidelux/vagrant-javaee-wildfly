# vagrant-javaee-wildfly
This project offers a basic Vagrant setup for JavaEE Projects with WildFly container.

## Prerequirements

In order to use this Vagrant configuration, you should install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) on your host machine.

## Dependencies

Before you can start using this project, you have to install the *vagrant-reload* plugin:

    $ vagrant plugin install vagrant-reload

In order to check if it was installed succesfull or if it is already installed, you can execute the following command:

    $ vagrant plugin list

## Usage

After you checked out this repository and added the dependencies as explained above, you can setup and start your development VM using the following command:

    vagrant up

## License

This basic setup is lisenced under the Apache 2.0 License.
