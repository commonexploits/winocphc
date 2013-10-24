WinOCPHC - Windows Offline Common Password Hash Checker

============================================

Auto review Windows Password hashes and compare looking for common password, disabled and previous passwords.

Useful for reviewing domain controller or local Windows password hashes. Will highlight common passwords used between users.
This can assist finding missing processes during a pen test, such as the Helpdesk configuring new users with all the same passwords and not forcing them to change the password at next login. Also things like no regular passwords changes or users being allowed to reset their passwords to previous values.

Ths script does not crack or attempt to crack hashes, it simply is an easy way to highlight issues. Often I find standard domain users have the same password set as domain administrators.


Developed by Daniel Compton

https://github.com/commonexploits/winocphc

Released under AGPL see LICENSE for more information

Installing  
=======================
    git clone https://github.com/commonexploits/winocphc.git


How To Use	
=======================
    ./winocphc


Features	
=======================

* Auto reads file output from hashdump, fgdump, gsecdump, pwdump etc
* Finds common passwords hashes and lists all users that share passwords
* Lists disabled accounts (if fgdump/gsecdump tool used and if exist)
* Lists and checks history passwords ((if fgdump/gsecdump tool used and if exist) and alerts if user has the same password as previously set
* Masks the hash output for reporting

Tested on Backtrack 5 and Kali.


Screen Shot    
=======================
<img src="http://commonexploits.com/wp-content/uploads/2013/10/1.jpg" alt="Screenshot" style="max-width:100%;">

<img src="http://commonexploits.com/wp-content/uploads/2013/10/2.jpg" alt="Screenshot" style="max-width:100%;">

<img src="http://commonexploits.com/wp-content/uploads/2013/10/3.jpg" alt="Screenshot" style="max-width:100%;">

<img src="http://commonexploits.com/wp-content/uploads/2013/10/4.jpg" alt="Screenshot" style="max-width:100%;">


Change Log
=======================

* Version 1.0 - First release.
