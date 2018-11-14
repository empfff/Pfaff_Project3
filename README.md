# Pfaff_Project3
1. I was not able to get the shiny app to work from the root directory of my project. So, I have included the command to serve the shiny app (from the /data directory) within my nextflow pipeline. If you already have something running on port 3838 or 8787, in order to not error out when running my pipeline, you may need to kill what you already have running there. 

You can issue a:

    docker ps -a

And find the ID for the docker instance currently taking up that port. Then issue a 

    docker kill <the ID number of the instance>

to free up the port. Then the nextflow pipeline should run just fine. Once done, you can do the same steps to kill my instance of docker.

I apologize if the way I set this up makes this more of a pain to grade--I just wasn't able to make the app work from the root directory, for whatever reason, and figured it was better to turn in something working.

2. Just running main.nf from my project folder should be enough to do the necessary computation and serve the app.