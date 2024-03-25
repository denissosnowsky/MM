No files changed, compilation skipped

Ran 21 tests for test/unit/ERC1155TokenTest.t.sol:ERC1155TokenTest
[32m[PASS][0m testAnyoneCanBurnOnlyOwnTokens() (gas: 404838)
[32m[PASS][0m testCannotMintAmountToNotExistedToken() (gas: 38105)
[32m[PASS][0m testCantAddRoyaltyToNotMintedToken() (gas: 44690)
[32m[PASS][0m testHasCommonRoayltyByDefault() (gas: 192666)
[32m[PASS][0m testIsInitialized() (gas: 36927)
[32m[PASS][0m testNotOwnerCannotCallWriteFunctions() (gas: 387407)
[32m[PASS][0m testOwnerCanChangeHasCommonRoyalty() (gas: 223922)
[32m[PASS][0m testOwnerCanChangeHasRoyalty() (gas: 245136)
[32m[PASS][0m testOwnerCanSetCommonRoyalties() (gas: 289441)
[32m[PASS][0m testOwnerCanSetIndividualRoyaltiesForEachToken() (gas: 445489)
[32m[PASS][0m testOwnerChangeSetBaseUri() (gas: 169523)
[32m[PASS][0m testOwnerMint() (gas: 393083)
[32m[PASS][0m testShouldReturnCommonRoyaltyForOneTokenWhenCommonRoyaltyIsOn() (gas: 423224)
[32m[PASS][0m testShouldReturnEmptyRoyaltiesWhenTherAreSwtichedOff() (gas: 180727)
[32m[PASS][0m testShouldRevertOnWrongRoyalty() (gas: 160599)
[32m[PASS][0m testShouldRevertOnWrongRoyaltyAddress() (gas: 158023)
[32m[PASS][0m testShouldRevertOnWrongRoyaltyAndAddressLength() (gas: 156990)
[32m[PASS][0m testTokenHasCorrectName() (gas: 9772)
[32m[PASS][0m testTokenHasCorrectOwner() (gas: 9840)
[32m[PASS][0m testTokenHasCorrectSymbol() (gas: 9792)
[32m[PASS][0m testTokenHasCorrectUri() (gas: 133662)
Suite result: [32mok[0m. [32m21[0m passed; [31m0[0m failed; [33m0[0m skipped; finished in 20.76ms (25.63ms CPU time)

Ran 20 tests for test/unit/ERC721TokenTest.t.sol:ERC721TokenTest
[32m[PASS][0m testAnyoneCanBurnOnlyOwnTokens() (gas: 348197)
[32m[PASS][0m testCantAddRoyaltyToNitMintedToken() (gas: 44709)
[32m[PASS][0m testHasCommonRoayltyByDefault() (gas: 168822)
[32m[PASS][0m testIsInitialized() (gas: 36883)
[32m[PASS][0m testNotOwnerCannotCallWriteFunctions() (gas: 215323)
[32m[PASS][0m testOwnerCanChangeHasCommonRoyalty() (gas: 200130)
[32m[PASS][0m testOwnerCanChangeHasRoyalty() (gas: 221326)
[32m[PASS][0m testOwnerCanSetCommonRoyalties() (gas: 265463)
[32m[PASS][0m testOwnerCanSetIndividualRoyaltiesForEachToken() (gas: 397869)
[32m[PASS][0m testOwnerChangeSetBaseUri() (gas: 146154)
[32m[PASS][0m testOwnerMint() (gas: 250495)
[32m[PASS][0m testShouldReturnCommonRoyaltyForOneTokenWhenCommonRoyaltyIsOn() (gas: 375519)
[32m[PASS][0m testShouldReturnEmptyRoyaltiesWhenTherAreSwtichedOff() (gas: 156835)
[32m[PASS][0m testShouldRevertOnWrongRoyalty() (gas: 136811)
[32m[PASS][0m testShouldRevertOnWrongRoyaltyAddress() (gas: 134235)
[32m[PASS][0m testShouldRevertOnWrongRoyaltyAndAddressLength() (gas: 133180)
[32m[PASS][0m testTokenHasCorrectName() (gas: 9750)
[32m[PASS][0m testTokenHasCorrectOwner() (gas: 9936)
[32m[PASS][0m testTokenHasCorrectSymbol() (gas: 9814)
[32m[PASS][0m testTokenHasCorrectUri() (gas: 110087)
Suite result: [32mok[0m. [32m20[0m passed; [31m0[0m failed; [33m0[0m skipped; finished in 20.79ms (24.74ms CPU time)

Ran 6 tests for test/unit/TokenFactoryTest.t.sol:TokenFactoryTest
[32m[PASS][0m testExternalUserCantUpgradeTokensImplementations() (gas: 2757491)
[32m[PASS][0m testFactoryOwnerCanUprgradeTokensImplementations() (gas: 5201442)
[32m[PASS][0m testShouldCreateERC1155TokenWithCorrectConfig() (gas: 809811)
[32m[PASS][0m testShouldCreateERC721TokenWithCorrectConfig() (gas: 809856)
[32m[PASS][0m testShouldERC1155TokenOwnableIsCorrect() (gas: 690447)
[32m[PASS][0m testShouldERC721TokenOwnableIsCorrect() (gas: 622365)
Suite result: [32mok[0m. [32m6[0m passed; [31m0[0m failed; [33m0[0m skipped; finished in 20.81ms (12.79ms CPU time)
| lib/openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol:BeaconProxy contract |                 |       |        |        |         |
|----------------------------------------------------------------------------------------|-----------------|-------|--------|--------|---------|
| Deployment Cost                                                                        | Deployment Size |       |        |        |         |
| 0                                                                                      | 0               |       |        |        |         |
| Function Name                                                                          | min             | avg   | median | max    | # calls |
| initialize                                                                             | 34016           | 34049 | 34049  | 34082  | 2       |
| mint()                                                                                 | 31441           | 66113 | 66118  | 100774 | 4       |
| mint(address)                                                                          | 31746           | 31855 | 31855  | 31964  | 2       |
| mint(address,uint256,bytes)                                                            | 32618           | 32618 | 32618  | 32618  | 1       |
| mint(address,uint256,uint256,bytes)                                                    | 32801           | 32801 | 32801  | 32801  | 1       |
| name                                                                                   | 2272            | 2272  | 2272   | 2272   | 2       |
| owner                                                                                  | 1378            | 1378  | 1378   | 1378   | 2       |
| setBaseURI                                                                             | 32272           | 32272 | 32272  | 32272  | 2       |
| setHasRoyalty                                                                          | 31739           | 31739 | 31739  | 31739  | 2       |
| setIsCommonRoyalty                                                                     | 31762           | 31762 | 31762  | 31762  | 2       |
| setRoyalties(address[],uint256[])                                                      | 32634           | 32634 | 32634  | 32634  | 2       |
| setRoyalties(uint256,address[],uint256[])                                              | 32781           | 32781 | 32781  | 32781  | 2       |
| symbol                                                                                 | 2314            | 2314  | 2314   | 2314   | 2       |
| tokenURI                                                                               | 3598            | 3598  | 3598   | 3598   | 2       |


| lib/openzeppelin-contracts/contracts/proxy/beacon/UpgradeableBeacon.sol:UpgradeableBeacon contract |                 |      |        |      |         |
|----------------------------------------------------------------------------------------------------|-----------------|------|--------|------|---------|
| Deployment Cost                                                                                    | Deployment Size |      |        |      |         |
| 0                                                                                                  | 0               |      |        |      |         |
| Function Name                                                                                      | min             | avg  | median | max  | # calls |
| implementation                                                                                     | 308             | 1558 | 2308   | 2308 | 48      |


| src/TokenFactory.sol:TokenFactory contract |                 |        |        |        |         |
|--------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                            | Deployment Size |        |        |        |         |
| 5762379                                    | 26201           |        |        |        |         |
| Function Name                              | min             | avg    | median | max    | # calls |
| createToken                                | 321640          | 331936 | 338740 | 338813 | 10      |
| getTokens()                                | 969             | 1106   | 1106   | 1243   | 4       |
| getTokens(address)                         | 1117            | 1281   | 1391   | 1391   | 10      |
| upgradeBeaconERC1155                       | 23935           | 32046  | 32046  | 40157  | 2       |
| upgradeBeaconERC721                        | 24000           | 32116  | 32116  | 40233  | 2       |


| src/tokens/ERC1155Token.sol:ERC1155Token contract |                 |        |        |        |         |
|---------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                   | Deployment Size |        |        |        |         |
| 2382931                                           | 11239           |        |        |        |         |
| Function Name                                     | min             | avg    | median | max    | # calls |
| balanceOf                                         | 680             | 680    | 680    | 680    | 7       |
| burn                                              | 24509           | 28524  | 28521  | 32544  | 4       |
| getRoyalties()                                    | 499             | 1591   | 1105   | 3243   | 5       |
| getRoyalties(uint256)                             | 863             | 3043   | 3635   | 3722   | 6       |
| initialize                                        | 3951            | 129488 | 143408 | 143408 | 29      |
| mint()                                            | 2415            | 100240 | 116629 | 116629 | 21      |
| mint(address)                                     | 2567            | 49367  | 54725  | 85452  | 4       |
| mint(address,uint256,bytes)                       | 3044            | 37097  | 24644  | 83603  | 3       |
| mint(address,uint256,uint256,bytes)               | 3093            | 18383  | 24821  | 27236  | 3       |
| name                                              | 3330            | 3330   | 3330   | 3330   | 1       |
| owner                                             | 2346            | 2346   | 2346   | 2346   | 1       |
| royaltyInfo(uint256)                              | 4003            | 4003   | 4003   | 4003   | 1       |
| royaltyInfo(uint256,uint256)                      | 4417            | 4430   | 4430   | 4444   | 2       |
| setBaseURI                                        | 2972            | 19074  | 24304  | 29948  | 3       |
| setHasRoyalty                                     | 2582            | 20965  | 26263  | 28752  | 4       |
| setIsCommonRoyalty                                | 2605            | 24293  | 28789  | 28801  | 8       |
| setRoyalties(address[],uint256[])                 | 3060            | 33597  | 28485  | 100506 | 11      |
| setRoyalties(uint256,address[],uint256[])         | 3073            | 48233  | 30127  | 103362 | 9       |
| symbol                                            | 3328            | 3328   | 3328   | 3328   | 1       |
| tokenURI                                          | 2396            | 3729   | 4396   | 4396   | 3       |
| totalSupply()                                     | 349             | 349    | 349    | 349    | 1       |
| totalSupply(uint256)                              | 538             | 538    | 538    | 538    | 4       |


| src/tokens/ERC721Token.sol:ERC721Token contract |                 |        |        |        |         |
|-------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                 | Deployment Size |        |        |        |         |
| 1997452                                         | 9457            |        |        |        |         |
| Function Name                                   | min             | avg    | median | max    | # calls |
| balanceOf                                       | 673             | 673    | 673    | 673    | 4       |
| burn                                            | 23891           | 27327  | 26687  | 32042  | 4       |
| getRoyalties()                                  | 499             | 1550   | 1053   | 3191   | 5       |
| getRoyalties(uint256)                           | 833             | 3028   | 3623   | 3710   | 6       |
| initialize                                      | 3885            | 128899 | 143313 | 143313 | 28      |
| mint()                                          | 2437            | 77426  | 92819  | 92819  | 22      |
| mint(address)                                   | 2589            | 45963  | 51261  | 78742  | 4       |
| name                                            | 1308            | 1974   | 1308   | 3308   | 3       |
| owner                                           | 420             | 1086   | 420    | 2420   | 3       |
| ownerOf                                         | 599             | 599    | 599    | 599    | 3       |
| royaltyInfo(uint256)                            | 3951            | 3951   | 3951   | 3951   | 1       |
| royaltyInfo(uint256,uint256)                    | 4405            | 4418   | 4418   | 4432   | 2       |
| setBaseURI                                      | 2972            | 19065  | 24304  | 29919  | 3       |
| setHasRoyalty                                   | 2582            | 20965  | 26263  | 28752  | 4       |
| setIsCommonRoyalty                              | 2605            | 24293  | 28789  | 28801  | 8       |
| setRoyalties(address[],uint256[])               | 3060            | 33597  | 28485  | 100506 | 11      |
| setRoyalties(uint256,address[],uint256[])       | 3073            | 48245  | 30145  | 103380 | 9       |
| symbol                                          | 1350            | 2016   | 1350   | 3350   | 3       |
| tokenURI                                        | 2631            | 3431   | 2631   | 4631   | 5       |




Ran 3 test suites in 48.88ms (62.36ms CPU time): [32m47[0m tests passed, [31m0[0m failed, [33m0[0m skipped (47 total tests)
