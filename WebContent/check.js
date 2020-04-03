

let loggedIn = false;

//function logout(){
//    loggedIn = false;
//    hideManagerLink();
//}

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
	readCookie();
    if(loggedIn == false){
        const manager = document.getElementById("ManagerLink");
        if(!manager.classList.contains("hidden")){
            manager.classList.add("hidden");
        }
        document.getElementById("loginDropdown").style.display = "block";
        document.getElementById("createAccountDropdown").style.display = "block";
        document.getElementById("myAccountDropdown").style.display = "none";
        document.getElementById("signOutDropdown").style.display = "none";
    }else{
        document.getElementById("loginDropdown").style.display = "none";
        document.getElementById("createAccountDropdown").style.display = "none";
        document.getElementById("myAccountDropdown").style.display = "block";
        document.getElementById("signOutDropdown").style.display = "block";
    }
});

function setCookie(email, isManager) {
	if(email === "") {
		alert("enter your email");
		return;
	}
	emailValue=escape(email) + ";"
	isManagerValue=escape(isManager) + ";"
	document.cookie = "email=" + emailValue;
	document.cookie = " isManager=" + isManagerValue;
}

function readCookie() {
	let allCookies = document.cookie;
	if(allCookies === "") {
		hideManagerLink();
		return;
	}
	//document.write ("All Cookies : " + allCookies);
	
	let cookieArray = allCookies.split(";");
	let emailArray = cookieArray[0].split("=");
	let isManagerArray = cookieArray[1].split("=");
	
	if(emailArray[0] === "email" && emailArray[1] === "") {
		logout();
	} else {
		if(isManagerArray[0] === " isManager" && isManagerArray[1] === "true") {
			login();
			showManagerLink();
		} else {
			login();
			hideManagerLink();
		}
	}
}

function signOut() {
	 let cookies = document.cookie;
     let cookieArray = cookies.split(";");
     for(var i = 0; i <cookieArray.length; i++) {
        var key = cookieArray[i].split("=");
        document.cookie = key[0]+" =; expires = Thu, 01 Jan 1970 00:00:00 UTC";
     }
	loggedIn = false;
}


