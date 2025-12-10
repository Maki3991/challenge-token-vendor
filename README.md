### 2025/12/09

> `YourToken public yourToken;`

- 定义了一个名为 yourToken 的变量，类型为 YourToken，实际上存储的和 address 数据类型一样都是地址（YourToken.sol 的地址），只不过如果类型为前者则可直接通过`yourToken.method`调用 YourToken.sol 内部的方法，而后者需要`.call`更为麻烦的方法

> `yourToken = YourToken(tokenAddress);`

- Vendor.sol 构造函数内的这段代码，作用是给刚刚定义的 yourToken 变量赋值。tokenAddress 通过 01_deploy_vendor.ts 文件取得 YourToken.sol 部署后的地址，`YourToken()`则将其包装成可直接调用方法的地址。所以整个构造函数的作用，就是把部署后的 YourToKen.sol 地址，以可以直接调用其内部方法的包装赋值给了 yourToken 变量

> `bool sent = yourToken.transfer(msg.sender, amountToBuy);` > `(bool sent, ) = msg.sender.call{ value: address(this).balance }("");`

- 两段代码都是在发币，但是上一个发送的是 ERC20 的代币，而下一个则是 ETH

### 2025/12/10

> `bool sent = yourToken.transfer(msg.sender, amountToBuy);` > `bool success = yourToken.transferFrom(msg.sender, address(this), amount);`

- ERC20 中 transfer(address to, uint256 amount)和 transferFrom(address from, address to, uint256 amount)的区别是：transfer()是“我把代币转到别人的地址”，而 transferFrom()是“（在别人始先 approve()后）我从别人的地址处转代币给我自己）”
