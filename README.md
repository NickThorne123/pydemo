This is an FMRI visualisation demo using Python Plotly and Dash

Based on the tutorial [here](https://plotly.com/python/visualizing-mri-volume-slices/)

Check you have git installed on your machine. How-to is [here](https://github.com/git-guides/install-git).

Read this 'hello world' git [tutorial](https://docs.github.com/en/get-started/quickstart/hello-world).

To us it, open your terminal application to access the comman line, cd into your workspace area and [git clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo.

cd into the created directory.

We now need to set up a virtual environment to ensure this project has it's own set of Python libraries and versions installed. For this we use venv, explained [here](https://realpython.com/lessons/setting-up-environment-pandas-venv/)

    python3 -m venv venv
    source venv/bin/activate
    pip3 install -r requirements.txt

Download [Visual Studio Code](https://code.visualstudio.com/download). 

(You can use PyCharm, but I can't help with the config)

Configure VS Code for Python as explained [here](https://code.visualstudio.com/docs/python/python-tutorial#_configure-and-run-the-debugger). Pay particular attention to [selecting the correct Python interpreter](https://code.visualstudio.com/docs/python/python-tutorial#_select-a-python-interpreter). Which should be the one in the venv subdirectory created earlier. If you don't do this then chances are your imports won't find the required libaries.

Open new window and select this directory.

You will notice the .vscode directory contains a file launch.json. And there is a 'run current file' option. This will launch whatever file is currently open. So open fmri.py and cick the triangle or play icon (4th down on the left).

Wait a few seconds and a URL of the form http://127.0.0.1:8050 should automatically open in your browser with the brain slice visualisation page as seen [here](https://plotly.com/python/visualizing-mri-volume-slices/).

QED
