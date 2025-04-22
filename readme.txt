Safa Abdalah
Spundun Gusain

---

Hello!
this is a cute little read me file so that you can use our configurations to mimic our deployment:

As of 04/22/2025
Dockerfile has been successfully created, and build and run has been tested and all seems well.

Here is how you can use our Dockerfile to build and run a container how we did.
Step 1, locate the sawayama-solitaire file (cloned from : https://github.com/blakewatson/sawayama-solitaire)

to build the docker file run in your terminal/bash:
docker build -t sawayama-solitaire .

then:
docker run -it -p 3000:8989 sawayama-solitaire

Beware there are pre-requisites to running these commands if they are not setup prior this will not work Please refer to our "troubleshooting file" which has not yet been created for any issues.
