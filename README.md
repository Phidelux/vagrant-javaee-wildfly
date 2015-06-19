# vagrant-javaee-wildfly
This project offers a basic Vagrant setup for JavaEE Projects with WildFly container.

## Prerequirements

In order to use this Vagrant configuration, you should install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) on your host machine.

## Dependencies

Before you can start using this project, you have to install the *vagrant-provision-reboot* plugin. Therfore check out the corresponding git repository:

    git clone https://github.com/exratione/vagrant-provision-reboot.git

And copy *vagrant-provision-reboot-plugin.rb* to the *vagrant* folder of this project. This will allow vagrant to reboot the virtual machine during the setup process in order to load newly installed kernels.

## Usage

After you checked out this repository and added the dependencies as explained above, you can setup and start your development VM using the following command:

    vagrant up

## License

This basic setup is lisenced under the Apache 2.0 License.
