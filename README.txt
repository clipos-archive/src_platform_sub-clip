sub-clip
========

sub-clip est un projet qui vise à harmoniser les outils des développeurs Clip.
Il est basé sur l'outil "sub" [1]. Plus précisement sur le fork de Nick
Quaranto [2].

Il permet d'automatiser et/ou de simplifier certaines actions répétitives.

Mise en place
-------------

Après le clone du projet, ajoutez la ligne suivante dans votre ~/.zshrc (ou votre ~/.bashrc):

    eval "$(/home/user/projets/sub-clip/bin/clip init -)"

Copiez le fichier share/clip/default-env.json dans votre répertoire maison sous
le nom ".sub-clip.json". Éditez-le pour y mettre vos préférences. Voir la section dédiée de cette page pour le détail.

Après avoir sourcé votre script, la commande "clip" est disponible. Elle est le cœur de sub-clip.

Exemples d'utilisation
----------------------

Les commandes sont autodocumentées. Par exemple, entrer "clip", donne la sortie
suivante:
   $ clip
   Usage: clip <command> [<args>]
   
   A collection of commands that ease Clip dev workflow
   
   Some useful clip commands are:
         bump               shortcut to in SDK clip-bump
         compact-mirrors    Change duplicates files into hard links in the mirror directory (rdfind is needed)
         compile            provide a shortcut to in SDK clip-compile
         dev-init           fetch new projects in clip-dev
         dev-update         update all known clip-dev projects
         dpkg               print various informations on a Clip .deb file
         edit-config        modify your sub "script" files
         edit-sub           change the sub files easily
         env                display sub-clip environment variables
      ↬  example            Collection of BASH Sub Example Scripts
         get-version        print the version of a "clip-int" directory
         git-optimize       run git repack and optimize your git tree away (should be useful on big repositories)
         manifest           shortcut to ebuild manifest
         mkarchive          make archive of the current directory
         mkmirror           make a clip installation or upgrade mirror
         prunepkgs          remove all obsolete packages from current directory (i.e. all packages for which a newe
         ssh                when started from a working clip-int directory, it ssh in the corresponding directory i
         start-lxc          start lxcs stated in conf file
         svn-clean-pkgs     clean the binary packages in the SDKs (before upping)
         update-rebase-all  update all clip ressources
         update-svn-pkgs    update the binary packages in the SDKs
         upgrade            Compile needed packages
         upgrade-vcs        Sign and move packaging from staging area to VCS dir
      ↬  virt               Collection of script for managing Virtual Machines (via libvirt)
   
   See 'clip help <command>' for information on a specific command.

La commande "help" fournit de l'aide sur les commandes:
    $ clip help mkarchive
    Usage: clip mkarchive tagname
    
    'tagname' is the prefix of the directory containing the archive
    It is prepended to the path of the files within the archive


Depuis le répertoire portage-overlay-clip/clip-conf/clip-core-conf d'un SDK:
    $ clip ssh ebuild clip-core-conf-4.4.2-r104.ebuild manifest
    >>> Creating Manifest for /mnt/clip-src/clip-git/clip-int-stable-4.4.2/portage-overlay-clip/clip-conf/clip-core-conf

Description du fichier .sub-clip.json
-------------------------------------

sub est capable de gérer plusieurs langages de scripting (Bash, Zsh, Perl, Python). Il est donc apparu comme important d'avoir rapidement un fichier de configuration commun aux différents scripts. Le fichier ~/.sub-clip.json répond à ce besoin. Si le parsing de fichier JSON est aisé en Python et Perl, il en va autrement pour Bash. C'est pourquoi sub-clip dispose d'une moulinette interne qui converti le JSON en variable Bash et en tableau associatif pour un usage plus aisé dans les scripts.

TBD

Étendre les scripts
-------------------

La commande "clip edit-sub" permet d'éditer les scripts. Les commandes sont
définies par des fichiers executable dont le nom est clip-nomdelacommande.

Les sous-commandes sont dans des répertoires et suivent la convention
clip-nomdelacommande/clip-nomdelasouscommande.

Le répertoire de script actuel est un bon endroit comprendre comment étendre et
ajouter de nouvelles commandes.


Travaux futurs
--------------

- harmonisation des noms
- inclure les sous-commandes clip-virt

Notes
-----

La complétion est actuellement cassée sur bash.

Liens
-----

[1]: https://github.com/basecamp/sub
[2]: https://github.com/jdevera/sub
