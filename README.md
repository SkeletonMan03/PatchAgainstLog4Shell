# Patch Against Log4Shell
This is for patching against Log4Shell in Windows via Powershell
# What it does
This searches your entire computer for jar files then checks them for JndiLookup.class which is the class that is vulnerable to Log4Shell then it removes that class  
Make it easy to patch Log4Shell
# Why?
Because most security software, such as Nessus, only look for the Log4j filename and report as vulnerable if it's below 2.16.  
Jar files can have this vulnerable dependency in it without the dependency being a separate jar file.  
Not all developers set the installer to have that dependency separate and may just compile it with the class in the Jar.  
It's possible for software to be vulnerable to it that Nessus or other scanning software isn't even looking for.  
The reason for patching this way is because official updates for software from some vendors have not yet been released or may never be released.  
Some users may also be using EoL software that is vulnerable and this is an option for patching that as well even though running EoL software is not ideal.  
# What is Log4Shell exactly?
See: https://en.wikipedia.org/wiki/Log4Shell  
# Dependencies
This requires 7-Zip, but if you don't have it, this script can install 7-Zip itself thanks to https://github.com/name.
# How to run
This is pretty easy to run  
Kill any Java applications you have running first!
1) Download the PatchAgainstLog4Shell.ps1 script
2) Launch Powershell as Administrator
3) Run `Set-ExecutionPolicy Bypass`
4) cd to the directory it is in (For example: `cd C:\Users\username\Downloads`)
5) Run `.\PatchAgainstLog4Shell.ps1` in the same Powershell Window

Alternatively, you can just run this in an Administrator Powershell window (not recommended, but it works):  
```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/SkeletonMan03/PatchAgainstLog4Shell/main/PatchAgainstLog4Shell.ps1'))
```

# Parameters
A parameter for just scanning without patching has been added  
You can run `.\PatchAgainstLog4Shell.ps1 -scanonly` to just scan for and print out the location of vulnerable jars without patching them automatically
