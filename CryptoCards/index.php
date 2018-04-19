<?php include "./include/header.php";?>
  <div class="content-wrapper">
    <div class="container-fluid">
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="#">Dashboard</a>
        </li>
        <li class="breadcrumb-item active">My Dashboard</li>
      </ol>
      <!-- Icon Cards-->
      <div class="row">
        <div class="col-xl-3 col-sm-3 mb-3">
          <div class="card text-white bg-success o-hidden h-100">
            <div class="card-body">
              <div class="card-body-icon">
                <img src="./img/logo-eth.png" height="150px">
              </div>
              <div class="mr-5">Comprar pack</div>
            </div>
            <a class="card-footer text-white clearfix small z-1" href="#">
              <span class="float-left">Compra tus packs aquí </span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>

      </div>
      <!-- Area Chart Example-->
      <div class="card mb-3">
        <div class="card-header" id="nombreT"></div>
        <div class="card-body">
          <div id="cards"></div>
        </div>
        <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
      </div>

    </div>
    <script>
      function remGrey(id){
        var element = document.getElementById(id);
        element.classList.remove("grey");
      }

      cryptoCardsAddress = "0x82d50ad3c1091866e258fd0f1a7cc9674609d254";
      var cryptoCards;
      var userAccount;


      function startApp() {
        cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        // userAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57";
        // console.log(userAccount);
        getCardsTotal()
        .then(createDisplayCards);
        // console.log(cryptoCards);
        // test = getCardsByOwner(userAccount, cryptoCards);
        // displayCards(test, cryptoCards);
        var accountInterval = setInterval(function() {
          // Check if account has changed
          if ("0x627306090abaB3A6e1400e9345bC60c78a8BEf57" !== userAccount) {
            userAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57";
            // Call a function to update the UI with the new account
            getCardsByOwner(userAccount)
            .then(displayCards);
          }
        }, 100);
      }

      function displayCards(ids) {

        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        for (id of ids) {
          remGrey(id);

          var elementCant = parseInt(document.getElementById("cantidad-"+id).textContent);
          elementCant++
          console.log(elementCant);
          document.getElementById("cantidad-"+id).innerHTML = elementCant;
        }
      }

      function createDisplayCards(ids) {
        $("#cards").empty();
        $("#nombreT").empty();
        getTeamDetails(0)
        .then(function(team) {
          var nombre = web3js.utils.toUtf8(team.name);
          nombre = nombre.toUpperCase();
          $("#nombreT").append(
            `<img src="./img/teams/0.png" height="30px">  ` + nombre + ` ${team.year}`);
        });
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        // for (id of ids) {
        //   $("#cards").append('<img src="./img/' + id + '.png" alt="Messi" class="grey" height="200px" id="' + id + '">');
        // }
        for (id of ids) {
          getCardsDetails(id)
          .then(function(card) {
            var nombre = web3js.utils.toUtf8(card.name);
            $("#cards").append(
              `<div class= "a grey" id="${card.idPlayer}">
                <img id="image1" class="img1" style="position: relative; width: 200px;" src="./img/tier2/${card.tier}.png"/>
                  <div class = "b">
                    <img id="image2" class="img2" style="position: absolute; width: 200px;" src="./img/player/1.png"/>
                    <div class = "c">
                      <p class="nombre">` + nombre + `</p>
                    </div>
                    <div class = "d">
                      <p class="nombre">x<span id="cantidad-${card.idPlayer}"> 0</span></p>
                    </div>
                  </div>
              </div>`
            );
          });
        }
      }

      function comprarPack() {
        // This is going to take a while, so update the UI to let the user know
        // the transaction has been sent
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        // Send the tx to our contract:
        cryptoCards.methods.packTester(2018).call({from: userAccount, gas: 9999999});
      }

      function getCardsByOwner() {
        // console.log(cryptoCards);
        return cryptoCards.methods.getCardsByOwner(userAccount).call()
      }

      function getCardsTotal() {
        // console.log(cryptoCards);
        return cryptoCards.methods.getCardTotal().call()
      }

      function getCardsDetails(id) {
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        return cryptoCards.methods.players(id).call();
      }

      function getTeamDetails(id) {
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        return cryptoCards.methods.teams(id).call();
      }

      window.addEventListener('load', function() {
        if (typeof web3 !== 'undefined') {
          // web3js = new Web3(web3.currentProvider);
          web3js = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
        } else {
          // set the provider you want from Web3.providers
          web3js = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
        }
        startApp()
      })

     </script>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->
<?php include "./include/footer.php";?>
