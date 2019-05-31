 <font size=5>
<p align="center">
  <img src="https://i.imgur.com/Um91eNE.png"/>
</p>

# PolyMuseum v1.0.2 #

---

> *PolyMuseum supporte  Android API 18++ et IOS 11.0+, besoin de gyroscope, bluetooth 4.0+, boussole, caméra, capteur d'accélération,composant de vibration, speaker, la mise en réseau*
## Interface ##
**Écran de Chargement**

- Quand vous lancez cette application, après une seconde de chargement vous pouvez choisir le type d'utilisateur, dont l'interface et les fonctions sont différentes, vous pouvez aussi passer à l’autre mode en cliquant le bouton Switch.

    ![](https://i.imgur.com/ikzy7CB.gif)

## Activité ##
**Détection du NFC**

- Quand vous cliquez sur le bouton Activités, la page ci-dessous s'affiche, vous pouvez voir une liste d'activité enregistrée dans la système, mais pour participer à l'activité, vous avez besoin de mettre votre téléphone sur le plateforme nfc, il va passer sur la page d’activité correspondante au tag NFC lu.
    - Course : La course commence de suite après avoir scanné le NFC, un chronomètre et votre vitesse courante s’affiche alors à l’écran. Un tag NFC se trouve au bout de la course, il vous suffit de poser votre téléphone dessus pour arrêter la course. Votre vitesse maximale s'affiche alors et vous pourrez ajouter votre nom au tableau des scores.
    - Tennis : Pour le tennis, vous recevez un certains nombre de points en fonction de la puissance de votre coup.
    
    ![](https://i.imgur.com/bvZgqgC.gif)

## Informations ##
**Scan d'un qr code**

- Quand vous cliquez sur le bouton "Scan Qr-Code", la page ci-dessous s'affiche. Vous invitant à scanner un qr code dans le musée.
    
    ![](https://i.imgur.com/xrcgGom.gif)

    - Si le scan se passe bien, les informations concernant l'objet en question s'affiche ainsi qu'un bouton vous permettant de répondre à une question sur l'objet.
    
    ![](https://i.imgur.com/QK8cMQX.gif)

    - Si vous scanné un qr code sans être dans la même pièce que cet objet, un message vous invitant à vous rapprocher de l'objet sera affiché. 

    - Pour tout autres erreurs (matériel, réseaux, etc..), le message suivant s'affiche.



## Explorer ##
**Localisation**

- Quand vous cliquez sur le bouton Explorer vous allez avoir une page ci-dessous, il faut un peu de temps pour mettre à jours ou télécharger la carte de musée et vous localiser précisément. Toutes les données des beacons, d'expositions et de la carte sont stockés séparéments dans la base de donnée en ligne, faciliter de les gérer. 

    ![](https://i.imgur.com/tow2xy2.gif)

> *Nous utilisons les beacons pour vous localiser parmis les différentes salles du musée. Quand vous entrez dans une salle, notre application va scanner des beacons proche de vous pour connaître votre position*

----------
**Orientation**

- Vous pouvez voir clairement votre orientation sur la carte, la flèche indiquant l’orientation va tourner en fonction..

    ![](https://i.imgur.com/RLGvaUY.gif)


> *Nous utilisons le capteur de boussole pour connaître votre orientation.*

----------
**Notification**

- Quand vous entrez dans une nouvelle région vous allez recevoir une notification locale qui contient des informations sur cette région.

    ![](https://i.imgur.com/efqus0E.gif)

----------
**Explorez des trésors**

- Dans certain région vous pouvez essayer de secouer votre téléphone pour scanner des trésors proche de vous, des points rouges vont s’afficher sur la carte avec une vibration et un bip pour indiquer où se trouvent les trésors s’ils existent. 

    ![](https://i.imgur.com/s6BTbVc.gif)

> *Nous utilisons le capteur d'accélération pour détecter le secouement. Vous devez secouer votre téléphone fortement comme vous êtes dans une musée du sport* *:)* 

----------
**Validez les trésors**

- Pour valider un trésor vous devez cliquer sur le bouton Scan et scanner le QRcode de ce tresors. Pour éviter la triche, vous pouvez valider un trésor seulement si vous êtes assez proche du trésor.

    ![](https://i.imgur.com/PeyPt4D.gif)

-  Si non vous allez recevoir une alerte vous demandant de vous rapprocher de l’objet, une fois le trésor validé, il va changer sa couleur à vert avec un bip.

    ![](https://i.imgur.com/qp3AJ3c.gif)

> *Nous utilisons la caméra pour scanner les QRcode*

----------
**Mission**

- Si vous n'avez pas d'idée où se trouve le trésor, pour obtenir des indices, vous pouvez cliquer sur le bouton Mission et vous pouvez ainsi avoir une description du trésor. Ça peut vous aider.

    ![](https://i.imgur.com/TD1ECb0.gif)

----------
## Quiz Personnalisé ##

- Si vous voulez avoir un quiz pour votre visite à musée, vous pouvez cliquer sur le bouton Quiz et choisir le nombre de question que vous voulez, il va générer automatiquement un quiz en fonction d'objet vous avez visité. Vous pouvez aussi avoir un document de format pdf si vous voulez tester votre étudiants après quelque jours.


	![](https://i.imgur.com/apdJgrt.gif)


----------
## Liste de Visit ##

- Si vous êtes un/une guide(professeur), vous pouvez générer une visite personnelle en scannant des QRCode de certain objet exposé, et puis vous pouvez cliquer sur le bouton Visite pour générer une clé pour votre touriste(étudiant) pour charger cette liste à sa checkliste.

    ![](https://i.imgur.com/5pGpXhY.gif)


- Si vous êtes un/une touriste(étudiant), vous pouvez cliquer sur le bouton et entrer la clé pour charger la liste fait par votre guide(professeur).

    ![](https://i.imgur.com/Fw4rOC0.gif)

</font>
