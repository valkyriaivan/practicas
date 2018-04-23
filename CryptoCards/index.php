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
          <div class="card text-white bg-success o-hidden h-100" onclick="comprarPack()">
            <div class="card-body">
              <div class="card-body-icon">
                <img src="./img/logo-eth.png" height="150px">
              </div>
              <div class="mr-5">Comprar pack</div>
            </div>
            <a class="card-footer text-white clearfix small z-1">
              <span class="float-left">Compra tus packs aquí </span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
              <!-- <button onclick="comprarPack()">Click me</button> -->
            </a>
          </div>
        </div>
        <div id="txStatus"></div>
        <div id="txStatus2"></div>

      </div>
      <!-- Area Chart Example-->
      <div class="card mb-3">
        <div class="card-header" id="nombreT"></div>
        <div class="card-body">
          <div id="cards"></div>
        </div>
        <div class="card-footer small text-muted">Autor: Ivan García Gálvez</div>
      </div>
      <!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter">
  Launch demo modal
</button>

<!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="packModal">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>

    </div>
    <script>
      function remGrey(id){
        var element = document.getElementById(id);
        element.classList.remove("grey");
      }

      cryptoCardsAddress = "0xe28158ecfde143e2536761c3254c7c31efd97271";
      var cryptoCards;
      var userAccount;
      // var packEvent;


      function startApp() {
        cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        // packEvent = cryptoCards.NewPack();
        // userAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57";
        // console.log(userAccount);
        getTeamsByYear()
        .then(sideBarTeams);

        getPlayersByTeam(<?php echo $_GET["idTeam"];?>)
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

        cryptoCards.events.NewPack()
        .on("data", function(event) {
          let data = event.returnValues;
          // console.log(data.packOwner);
          $("#txStatus2").text("Has comprado un sobre!" + data.packOwner);
        }).on("error", console.error);
      }

      function displayCards(ids) {

        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        var nameEls = document.getElementsByClassName('cant');
        for (var i = 0; i < nameEls.length; i++) {
          nameEls[i].innerHTML = 0;
        }

        setTimeout(function(){
          for (id of ids) {
            remGrey(id);

            var elementCant = parseInt(document.getElementById("cantidad-"+id).textContent);
            elementCant++
            document.getElementById("cantidad-"+id).innerHTML = elementCant;
          }
        }, 500);
      }

      function createDisplayCards(ids) {
        $("#cards").empty();
        $("#nombreT").empty();
        getTeamDetails(<?php echo $_GET["idTeam"];?>)
        .then(function(team) {
          var nombre = web3js.utils.toUtf8(team.name);
          nombre = nombre.toUpperCase();
          $("#nombreT").append(
            `<img src="./img/teams/${team.idTeam}.png" height="30px">  ` + nombre + ` ${team.year}`);
        });
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
                      <p class="nombre">x<span id="cantidad-${card.idPlayer}" class="cant"> 0</span></p>
                    </div>
                  </div>
              </div>`
            );
          });
        }
      }

      function sideBarTeams(ids) {
        // $("#cards").empty();
        // $("#nombreT").empty();
        for (id of ids) {
          getTeamDetails(id)
          .then(function(team) {
            var nombre = web3js.utils.toUtf8(team.name);
            nombre = nombre.toUpperCase();
            $("#exampleAccordion").append(
              `<li class="nav-item" data-toggle="tooltip" data-placement="right" title="Dashboard">
                <a class="nav-link" href="index.php?idTeam=${team.idTeam}">
                  <i><img src="./img/teams/${team.idTeam}.png" height="25px"></i>
                  <span class="nav-link-text">` + nombre + `</span>
                </a>
              </li>`)
              // `<img src="./img/teams/0.png" height="30px">  ` + nombre + ` ${team.year}`);
          });
        }
      }

      function comprarPack() {
        cryptoCards.methods.packTester(2018)
        .send({ from: userAccount, gas: 3000000 })
        .on("receipt", function(receipt) {
          $("#txStatus").text("Has comprado un sobre!");
          getCardsByOwner(userAccount)
          .then(displayCards);
          getOwnerLastPack(userAccount)
          .then(displayPack);
        })
        .on("error", function(error) {
          $("#txStatus").text(error);
        });
      }

      function displayPack(packCards) {
        console.log(packCards)
        for (packCard of packCards) {
          getCardsDetails(packCard)
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
                      <p class="nombre">x<span id="cantidad-${card.idPlayer}" class="cant"> 0</span></p>
                    </div>
                  </div>
              </div>`
            );
          });
        }
        $("#exampleModalCenter").modal()
      }

      // function buyPack() {
      //   comprarPack()
      //   .then(displayPack);
      // }




      // function comprarPack() {
      //   // return cryptoCards.methods.packTester(2018).send({ from: userAccount, gas: 3000000 });
      //   cryptoCards.methods.packTester(2018).send({ from: userAccount, gas: 3000000 })
      // }
      function getCardsByOwner() {
        // console.log(cryptoCards);
        return cryptoCards.methods.getCardsByOwner(userAccount).call()
      }
      function getTeamsByYear(){
        return cryptoCards.methods.getTeamsByYear(2018).call()
      }

      function getPlayersByTeam(team) {
        // console.log(cryptoCards);
        return cryptoCards.methods.getPlayersByTeam(team).call()
      }

      function getCardsDetails(id) {
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        return cryptoCards.methods.players(id).call()
      }

      function getTeamDetails(id) {
        // var cryptoCards = new web3js.eth.Contract(cryptoCardsABI, cryptoCardsAddress);
        return cryptoCards.methods.teams(id).call()
      }


      window.addEventListener('load', function() {
        if (typeof web3 !== 'undefined') {
          // web3js = new Web3(web3.currentProvider);
          web3js = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
          // web3js = new Web3(web3.currentProvider);
        } else {
          // set the provider you want from Web3.providers
          web3js = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
          // web3js = new Web3(web3.currentProvider);
        }
        startApp()
      })

     </script>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->
<?php include "./include/footer.php";?>
