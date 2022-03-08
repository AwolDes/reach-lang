[{"bookPath":"guide","title":"How do network and non-network tokens differ?","titleId":"guide-nntoks","hasOtp":true,"hasPageHeader":true},"<p><i id=\"p_0\" class=\"pid\"></i>Reach assumes that network tokens and non-network tokens behave identically on consensus networks, but this is not the case in practice.<a href=\"#p_0\" class=\"pid\">0</a></p>\n<h2 id=\"how-do-network-tokens-behave\" class=\"refHeader\">How do network tokens behave?<a aria-hidden=\"true\" tabindex=\"-1\" href=\"#how-do-network-tokens-behave\"><span class=\"icon icon-link\"></span></a></h2>\n<p>\n  <i id=\"p_1\" class=\"pid\"></i>An account on a consensus network can hold network tokens and as long as the network is available, it may send these tokens to other accounts or receive tokens from other accounts without preapproval from recipients and without the interference of third-parties not involved in a particular transfer.\n  Each network may prescribe fees on transfers or other similar constraints on transfers (such as a minimum balance holding to send funds) but may not restrict the reception of funds or arbitrarily hold or reclaim network tokens.\n  All consensus networks that Reach supports obey these properties.<a href=\"#p_1\" class=\"pid\">1</a>\n</p>\n<h2 id=\"how-do-non-network-tokens-violate-this\" class=\"refHeader\">How do non-network tokens violate this?<a aria-hidden=\"true\" tabindex=\"-1\" href=\"#how-do-non-network-tokens-violate-this\"><span class=\"icon icon-link\"></span></a></h2>\n<p><i id=\"p_2\" class=\"pid\"></i>In each of the networks supported by Reach, non-network tokens may violate these expectations.<a href=\"#p_2\" class=\"pid\">2</a></p>\n<p>\n  <i id=\"p_3\" class=\"pid\"></i>On Ethereum, and Ethereum-like networks, where non-network tokens are just particular patterns of smart contracts, the concrete behavior of abstract operations like \"Transfer 10 Zorkmids from John to Paul\" may have arbitrary semantics.\n  For example, a smart contract insisting that Paul pre-approve the reception of Zorkmids;\n  a smart contract could allow all transfers to be universally halted, like an old-fashioned bank closure;\n  a smart contract could simply take John's Zorkmids away because the administrator of the token decides to;\n  and so on.\n  Smart contracts have power to implement arbitrary semantics and there is no guarantee that a smart contract that supplies a function with the name <code>transfer</code> and the signature <code>function transfer(address _to, uint256 _value) public returns (bool success)</code> has any particular behavior.\n  Furthermore, you can send network tokens to a contract as you create it, but you cannot send non-network tokens, because sending non-network tokens (using ERC-20) requires knowing a contract's address, which you cannot know until after you create it (unless you use a particular low-level creation operation).<a href=\"#p_3\" class=\"pid\">3</a>\n</p>\n<p>\n  <i id=\"p_4\" class=\"pid\"></i>On Algorand, non-network tokens are built into the network, so they have a stable and predictable semantics, but that semantics is different than network tokens.\n  For example, non-network token reception must be pre-approved so John cannot transfer to Paul unless Paul has predetermined he is willing to accept Zorkmids.\n  Furthermore, non-network token creation supports options which have further differences:\n  it may be possible to \"freeze\" all transfers, so that no one can make any transfers; and,\n  it may be possible to \"clawback\" balances, so that John's Zorkmids can be removed from his account without his intervention.<a href=\"#p_4\" class=\"pid\">4</a>\n</p>\n<p><i id=\"p_5\" class=\"pid\"></i>On each network, it is possible to minimize these differences---by disabling these options and obeying a standard semantics---but that behavior is not universal among all tokens.<a href=\"#p_5\" class=\"pid\">5</a></p>\n<p><i id=\"p_6\" class=\"pid\"></i>Non-network tokens minted by Reach always disable these options and behave as closely as possible to network tokens.<a href=\"#p_6\" class=\"pid\">6</a></p>\n<h2 id=\"why-does-this-matter\" class=\"refHeader\">Why does this matter?<a aria-hidden=\"true\" tabindex=\"-1\" href=\"#why-does-this-matter\"><span class=\"icon icon-link\"></span></a></h2>\n<p><i id=\"p_7\" class=\"pid\"></i>These issues matter because developers and users of their applications need to understand that when they interact with a non-network token, they are interacting with a third party that can potentially control their application's behavior.<a href=\"#p_7\" class=\"pid\">7</a></p>\n<p>\n  <i id=\"p_8\" class=\"pid\"></i>For example, suppose George and Ringo decide to play poker on a consensus network and bet Zorkmids, rather than network tokens.\n  If the manager of Zorkmids, Zorkmanager, freezes them, then the game must stop.\n  If the game requires that hands be provided in a timely fashion, then George could bribe Zorkmanager to freeze them every time it is Ringo's turn, forcing him to forfeit a round.<a href=\"#p_8\" class=\"pid\">8</a>\n</p>\n<p>\n  <i id=\"p_9\" class=\"pid\"></i>Suppose at the end of the game, there is a pot of 200 Zorkmids with 5 meant for George and 195 meant for Ringo.\n  If Zorkmanager takes 1 Zorkmid from the pot via \"clawback\", then only one of the parties can be paid in full.\n  What's worse, an application may be programmed to either transfer everything or nothing, so in this scenario if George extracts first, then Ringo will not be able to extract anything.\n  Furthermore, suppose the application is programmed to clear the pot atomically, disbursing to each player in one single step;\n  in this scenario, if recipients are required to pre-authorize holding a token, then George can revoke that permission to spite Ringo and prevent him from getting his allocation.<a href=\"#p_9\" class=\"pid\">9</a>\n</p>\n<p><i id=\"p_10\" class=\"pid\"></i>In summary, non-network tokens' semantics are non-intuitive considering the power given to their creators.<a href=\"#p_10\" class=\"pid\">10</a></p>\n<h2 id=\"what-does-reach-do-about-this\" class=\"refHeader\">What does Reach do about this?<a aria-hidden=\"true\" tabindex=\"-1\" href=\"#what-does-reach-do-about-this\"><span class=\"icon icon-link\"></span></a></h2>\n<p>\n  <i id=\"p_11\" class=\"pid\"></i>Reach uses a verification engine to model the semantics of Reach programs to predict and reason about their behavior.\n  In particular, it tries to prove two theorems:<a href=\"#p_11\" class=\"pid\">11</a>\n</p>\n<ul>\n  <li><i id=\"p_12\" class=\"pid\"></i><strong>Honesty</strong>: Honest participants will not submit transactions that will be rejected.<a href=\"#p_12\" class=\"pid\">12</a></li>\n  <li><i id=\"p_13\" class=\"pid\"></i><strong>Progress</strong>: If honest participants submit transactions, the program will finish.<a href=\"#p_13\" class=\"pid\">13</a></li>\n</ul>\n<p>\n  <i id=\"p_14\" class=\"pid\"></i>If a program contains an operation such as \"Transfer 10 tokens to John\", then there are certain pre-conditions that must be true for this operation to succeed, such as \"The contract holds at least 10 tokens\".\n  Reach will guarantee that every pre-condition in the program is entailed by the earlier parts of the program.\n  When pre-conditions depend on user input, it will ensure that honest participants check that input before submitting the transaction.<a href=\"#p_14\" class=\"pid\">14</a>\n</p>\n<p>\n  <i id=\"p_15\" class=\"pid\"></i>Non-network tokens, because they are arbitrary code on some networks and depend on transient state controlled by third-parties on other networks, have no semantics, and therefore, have no predictable pre-conditions.\n  This means that it is impossible to predict whether an operation will succeed or fail simply by knowing it (for example) follows the ERC-20 specification or is an Algorand Standard Asset.<a href=\"#p_15\" class=\"pid\">15</a>\n</p>\n<p><i id=\"p_16\" class=\"pid\"></i>In our design of Reach, we had three choices when contemplating how to manage such unpredictability.<a href=\"#p_16\" class=\"pid\">16</a></p>\n<p>\n  <i id=\"p_17\" class=\"pid\"></i>First, we could represent non-network token operations as free terms with no semantics, and thus unpredictable behavior.\n  We did not do this, because users expect they'll have a particular behavior (most actually do!) and expect that Reach's token linearity verification will apply to non-network tokens as well.<a href=\"#p_17\" class=\"pid\">17</a>\n</p>\n<p>\n  <i id=\"p_18\" class=\"pid\"></i>Second, we could explicitly represent the details of the power each network gives to non-network token creators and include their state space in the analysis of Reach programs.\n  We did not do this, because it is impossible to write programs that are generic in the non-network tokens they use with this token.\n  In other words, a Reach program that implemented a poker game couldn't be constructed to use <em>some</em> token.\n  Rather, it would have to be a game that used <em>Zorkmids</em>, and you'd have to write (or verify) another program for a game that used <em>Gil</em>, and so on.\n  Given that most tokens actually behave properly, this would be unnecessarily painful for productive programming.<a href=\"#p_18\" class=\"pid\">18</a>\n</p>\n<p>\n  <i id=\"p_19\" class=\"pid\"></i>Third, we can assume that non-network tokens behave the same as network tokens and document the differences and educate developers and users about the consequences of this.\n  Clearly, this is what we did.<a href=\"#p_19\" class=\"pid\">19</a>\n</p>\n<h2 id=\"what-can-i-do-about-it\" class=\"refHeader\">What can I do about it?<a aria-hidden=\"true\" tabindex=\"-1\" href=\"#what-can-i-do-about-it\"><span class=\"icon icon-link\"></span></a></h2>\n<p>\n  <i id=\"p_20\" class=\"pid\"></i>First, if you use non-network tokens, you need to understand that you are trusting the token issuer as much as you are trusting the consensus network itself.\n  This means that you need to audit its code, or configuration, and decide if you can place trust in its manager.<a href=\"#p_20\" class=\"pid\">20</a>\n</p>\n<p><i id=\"p_21\" class=\"pid\"></i>Second, if your token requires pre-authorization of receipt, and if this pre-authorization can be revoked, you need to remove atomic simultaneous transfers of non-network tokens from your program and replace them with phases where each party can receive their tokens individually, so that one party cannot maliciously opt-out to prevent the other party from receiving their funds.<a href=\"#p_21\" class=\"pid\">21</a></p>\n<p><i id=\"p_22\" class=\"pid\"></i>Finally, you can advocate, perhaps with your money and support, that consensus networks pursue giving non-network tokens feature parity with network tokens so that there will be a consensus network that can faithfully implement the token semantics users expect.<a href=\"#p_22\" class=\"pid\">22</a></p>","<ul><li class=\"dynamic\">\n    <a href=\"#guide-nntoks\">How do network and non-network tokens differ?</a>\n    <ul class=\"dynamic\">\n      <li class=\"dynamic\"><a href=\"#how-do-network-tokens-behave\">How do network tokens behave?</a></li>\n      <li class=\"dynamic\"><a href=\"#how-do-non-network-tokens-violate-this\">How do non-network tokens violate this?</a></li>\n      <li class=\"dynamic\"><a href=\"#why-does-this-matter\">Why does this matter?</a></li>\n      <li class=\"dynamic\"><a href=\"#what-does-reach-do-about-this\">What does Reach do about this?</a></li>\n      <li class=\"dynamic\"><a href=\"#what-can-i-do-about-it\">What can I do about it?</a></li>\n    </ul>\n  </li></ul>"]