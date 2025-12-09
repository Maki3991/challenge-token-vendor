### 2025/12/09
> `YourToken public yourToken;`
- 定义了一个名为 yourToken 的变量，类型为YourToken，实际上存储的和address数据类型一样都是地址（YourToken.sol的地址），只不过如果类型为前者则可直接通过`yourToken.method`调用YourToken.sol内部的方法，而后者需要`.call`更为麻烦的方法

> `yourToken = YourToken(tokenAddress);`
- Vendor.sol构造函数内的这段代码，作用是给刚刚定义的yourToken变量赋值。tokenAddress通过01_deploy_vendor.ts文件取得YourToken.sol部署后的地址，`YourToken()`则将其包装成可直接调用方法的地址。所以整个构造函数的作用，就是把部署后的YourToKen.sol地址，以可以直接调用其内部方法的包装赋值给了yourToken变量

> `bool sent = yourToken.transfer(msg.sender, amountToBuy);`
> `(bool sent, ) = msg.sender.call{ value: address(this).balance }("");`
- 两端代码都是在发币，但是上一个发送的是ERC20的代币，而下一个则是ETH
