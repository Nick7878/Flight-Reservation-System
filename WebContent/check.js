

let loggedIn = false;

function logout(){
    loggedIn = false;
}

function login(){
    loggedIn = true;
}

function hideManagerLink() {
	var managerLink = document.getElementById("ManagerLink");
	managerLink.classList.add("hidden");
}

function showManagerLink() {
	var managerLink = document.getElementById("ManagerLink");
	managerLink.classList.remove("hidden");
}

document.addEventListener("DOMContentLoaded" , () =>{
    if(loggedIn == false){
        const manager = document.getElementById("ManagerLink");
        if(!manager.classList.contains("hidden")){
            manager.classList.add("hidden");
        }
        document.getElementById("loginDropdown").style.display = "block";
        document.getElementById("createAccountDropdown").style.display = "block";
    }else{
        document.getElementById("loginDropdown").style.display = "none";
        document.getElementById("createAccountDropdown").style.display = "none";
    }
});


