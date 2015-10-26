require('util');

describe('home page', function  () {

	var ptor = protractor.getInstance();

	beforeEach(function () {
		 // browser.get('http://www.angularjs.org');
		 browser.get('http://192.168.33.202:9000/#/index');
	});

	it('login', function () {

		// var input = ptor.findElement(protractor.By.model('yourName'));
		// input.sendKeys('Rafael');
		// var nameLabel = ptor.findElement(protractor.By.binding('yourName'));
		// expect(nameLabel.getText()).toEqual("Hello Rafael!");

		var btnAcceder = ptor.findElement(protractor.By.css('#login-register-section .btn-white'));
		btnAcceder.click();

		browser.getCurrentUrl().then(function (getCurrentUrl) {
			expect(getCurrentUrl).toContain('login');
		});

		var inputName = ptor.findElement(protractor.By.model('data.userName'));
		var inputPass = ptor.findElement(protractor.By.model('data.password'));
		
		expect(inputName.isDisplayed()).toBe(true);
		expect(inputPass.isDisplayed()).toBe(true);

		inputName.sendKeys('rafa.avim@gmail.com');
		inputPass.sendKeys('Corpfolder12');

		var btnLogin = ptor.findElement(protractor.By.name('loginEntrar'));

		btnLogin.click();
	});
});