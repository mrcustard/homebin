# Auto adding hosts to groups in M/Monit

* How do we do this? 
1. Have the node run a script that would query M/Monit, 
   and return it's id, and it would attempt to add itself 
   to the correct group or groups.

Prereqs: 
  1. The group would have to be there or at the very least 
     be created by the first host that was going to be adding
     itself to the group


Observations: 
  1. This is going to be intensive (at least in the short term),
     so we need to make sure that  
     we only run this script every 5 minutes, until it has added
     itself, once that happens we should stop running the script
     all together. So we will have to have a first run or some
     such to ensure that the script doesn't run again. 
  2. Nodes will be added to groups, however when they are deleted
     we need to ensure that they are deleted from groups as well.
     In that case the host delete should work really well, however
     we need to make sure.

