

let loggedIn = false;

function logout(){
    loggedIn = false;
}

function login(){
    loggedIn = true;
}

document.addEventListener("DOMContentLoaded" , () =>{
    if(loggedIn == false){
        const manager = document.getElementById("ManagerLink");
        if(manager.style.opacity == "100%"){
            manager.style.opacity = "0%";
        }
        document.getElementById("loginDropdown").style.display = "block";
        document.getElementById("createAccountDropdown").style.display = "block"
    }else{
        document.getElementById("LoginDropdown").style.display = "none";
        document.getElementById("createAccountDropdown").style.display = "none"
    }
});


