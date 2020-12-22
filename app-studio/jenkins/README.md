Jenkins Multibranch Pipeline
============================

LUCIDWORKS SOLUTIONS ONLY. NOT FOR DISTRIBUTION.


Running on Jenkins
------------------

Create a new Multibranch Pipeline job, and set it to search for the declarative pipeline file in 
`jenkins/Jenkinsfile`

Building locally
----------------

Run `./local-docker-build.sh`.  This will replicate the Jenkins build, minus the Jenkins-specific 
steps of notifying Slack and archiving artifacts.

You will need Docker installed to build locally.

Maintenance
===========

Adding build tools
------------------

If additional, or newer, build tools are required, add these to the build-time Docker image by 
editing the `Dockerfile`

Changing build steps
--------------------

The Maven invocation is run via `build-inner.sh`.  Edit this if different parameters should be passed in.

