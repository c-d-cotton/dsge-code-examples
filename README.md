# Introduction
Simulation of simple RBC model using perturbation methods. I use several different approaches:
- One-Off Code (oneoff/ directory)
- Schmitt-Grohe Uribe's code (sgu/ directory)

# Installation
<!---INSTALLATION_WGET_SUBMODULES_START.-->
I found standard methods for managing submodules to be a little complicated so I use my own method for managing my submodules. I use the mysubmodules project to quickly install these. To install the project, it's therefore sensible to download the mysubmodules project and then use a script in the mysubmodules project to install the submodules for this project.

If you are in the directory where you wish to download dsge-code-examples i.e. if you wish to install the project at /home/files/dsge-code-examples/ and you are at /home/files/, and you have not already cloned the directory to /home/files/dsge-code-examples/, you can run the following commands to download the directory:

```
wget -r -np --reject "index.html*" -nH --cut-dirs=2 http://www.cdcotton.com/code/public/dsge-code-examples/
git clone https://github.com/c-d-cotton/mysubmodules.git getmysubmodules
python3 getmysubmodules/singlegitmodule.py dsge-code-examples --deletegetsubmodules
```

See http://stackoverflow.com/questions/273743/using-wget-to-recursively-fetch-a-directory-with-arbitrary-files-in-it for an explanation of the wget command (-r is recursive, -np prevents downloading parent directories, --reject "index.html\*" prevents downloading index files, -nH prevents www.cdcotton.com/ folder, --cut-dirs=2 prevents code/public/ folders).
<!---INSTALLATION_WGET_SUBMODULES_END.-->

