![Made by](https://img.shields.io/badge/Made%20by-Shell-%23ff0000?style=flat-square&logo=bash&logoColor=white&labelColor=%23000000)
![Latest version](https://img.shields.io/badge/Latest-version-%23000000?style=flat&labelColor=%230000ff)
[![youtube](https://img.shields.io/badge/youtube-Watch%23on%23YouTube-%23000000?style=flat-square&logo=youtube&logoColor=white&labelColor=%23ff0000)](https://youtu.be/V58od-9IP1U)
![Github](https://img.shields.io/badge/Github-green?style=flat-square)

# About this tool 
I scripted this tool to automate because we need to upload different files to our GitHub repository from time to time.Then executing a comment and uploading it is a lot of trouble and a lot of time wasted. For this, I created this script so that we can do the work in a very short time.

![Screenshot_2024-04-08-15-48-39-941_com offsec nhterm](https://github.com/mashunterbd/github/assets/108648096/c0fcc49a-ec3f-4205-99f0-7d4447b62b79)


# Install in Linux Distro
![Linux](https://img.shields.io/badge/Linux-blue?style=flat-square)
```
wget -O install.sh https://raw.githubusercontent.com/mashunterbd/github/main/install.sh && chmod +x install.sh && bash install.sh
```

# Requirements
To use it you must need the <b> API </b>  token of your GitHub Account. </br>
dependency: <b> git </b> 

# Uges
```
┌──(root㉿kali)-[/]
└─# github --help

It is basically an automatic tool through which you can create a repository and upload your files there remotely and delete them if you want. In this case only your account should have API token.


Usegs:

 github [option]


 -push: Publish all files in your current directory to your GitHub account.

 -del: Delete any repository in your account.

 --help: Display uses.

 -v: Check for version.

```
# How can I get my API token 
<b> To get your API token from your GitHub account, you can follow these steps: </b>

<b> Log in to GitHub</b>: Go to the GitHub website (https://github.com/) and log in to your GitHub account if you haven't already.

<b>Go to Settings </b>: Click on your profile picture in the top-right corner of the page, then click on "Settings" from the dropdown menu.

<b> Navigate to Developer Settings</b>: In the left sidebar of the Settings page, click on "Developer settings".

Generate a New Token: In the Developer settings page, click on "Personal access tokens" from the left sidebar, then click on the "Generate new token" button.

Configure Token: Enter a description for your token to remember its purpose. Then, select the scopes (permissions) for the token based on what you need it for. Make sure to only grant the permissions necessary for your intended use.

Generate Token: After configuring the token, click on the "Generate token" button at the bottom of the page.

Copy Token: Once the token is generated, copy it to a safe place. This is the only time you'll be able to see the token, so make sure to copy it securely.

<b> Store Token Securely </b>: Treat your API token like a password and store it securely. Do not share it with anyone and avoid committing it to public repositories.

That's it! You now have your API token from your GitHub account, which you can use for various purposes such as accessing GitHub's API or authenticating with GitHub services.
