## GRUB2 Theme Aurora Penguinis

Author: Georg Eckert

Based on: Vimix GRUB2 Theme by vinceliuice.


# Installation


* Download and extract [Aurora-Penguinis-GRUB2.tar.gz](https://bitbucket.org/gemlion/aurora-penguinis/raw/1d4a0a8d06629d349f64806a3ada9661d609a247/Aurora-Penguinis-GRUB2.tar.gz)
* Copy the whole folder with root privileges to **/boot/grub/themes/**
* Edit **/etc/default/grub** and add:

```
GRUB_THEME="/boot/grub/themes/Aurora-Penguinis-GRUB2/theme.txt"
```

* Update grub :

```bash
$ grub-mkconfig -o /boot/grub/grub.cfg

```

***


# Sources


Background Picture: [Official KDE5.3 Wallpaper](https://projects.kde.org/projects/kde/workspace/breeze/repository/revisions/master/changes/wallpapers/Next/contents/images/1600x1200.png)

GRUB2 Theme Vimix by [vinceliuice	vinceliuice](http://gnome-look.org/content/show.php/Grub-themes-vimix?content=169954)


License
=======
Modified KDE5.3 Wallpaper: LGPL
Everything else: GPL

