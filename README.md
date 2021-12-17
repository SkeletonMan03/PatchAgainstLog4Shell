# PatchAgainstLog4Shell
This is for patching against Log4Shell in Windows via Powershell
# What it does
This searches your entire C:\ drive for jar files then checks them for JndiLookup.class which is the class that is vulnerable to Log4Shell then it removes that class
# Why?
Because most software, such as Nessus, only look for the Log4j filename and report as vulnerable if it's below 2.16.  
Jar files can have it in it without it being a separate jar file. Not all developers set the installer to have that dependency separate and just compile it with the class in the Jar.  
It's possible for software to be vulnerable to it that Nessus or other scanning software isn't even looking for.  
# Dependencies
This requires 7-Zip, if you don't have it, install it first
# How to run
This is pretty easy to run  
Kill any Java apllications you have running first!
1) Download the PatchAgainstLog4Shell.ps1 script
2) Launch Powershell as Administrator
3) Run Set-ExecutionPolicy Bypass
4) cd to the directory it is in
5) Run PatchAgainstLog4Shell.ps1 in the same Powershell Window
