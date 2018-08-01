## Image editor for aws-xray-kubernetes

Provides a simple way to redeploy new images for the [aws-xray-kubernetes](https://github.com/aws-samples/aws-xray-kubernetes) project after editing them.

* build-apps.sh - Rebuilds images, pushes them to your docker repo, and deploys them to your kubernetes cluster.



### Usage:

**create a configuration file**

    mv app-sample.conf app.conf

**edit app.conf with values for your setup**



    APP_REPO_A='mydockerrepo/xray-demo-service-a'
    APP_REPO_B='mydockerrepo/xray-demo-service-b'
    DAEMON_REPO='mydockerrepo/xray-daemon'


**set docker login environmental variables**

    export DOCKER_USERNAME='MY_USERNAME'
    export DOCKER_PASSWORD='MY_PASSWORD'


**edit apps as desired**

    nano demo-app/service-a/server.js

**Rebuild and deploy**

    ./build-apps.sh



## License

This project is licensed under the Apache 2.0 License.
