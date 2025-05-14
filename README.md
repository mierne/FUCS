# About
The Free Utility for Cloning Saves aka FUCS is batch script tool that allows users to create list of folders which they can easily backup en masse at the click of a button, or in this case, a key.

## Usage
FUCS is still in development. This section will be filled out once all intended features have been implemented.

## Issues
Likely due to my misunderstanding of FOR or ROBOCOPY, FUCS' current state is less than ideal. The source directory has it's contents copied, but to the destination directory instead of a copy of itself in the desitation, which is the intended behaviour.
So far I have attempted to append the folder name from the Masterlist in order to make a directory and copy the files there. 

The actual result however is that any source directories in the masterlist will be made, but they will all contain the same contents.
The /MIR switch does not solve this issue. I understand Batch Script is probably the worst language to perform this in, but I feel as if ROBOCOPY itself is almost too limited. Source directories not being able to be cloned is a very strange thing.

## Contributing
Everyone is free to contribute! Just be sure you read the license and be kind.
