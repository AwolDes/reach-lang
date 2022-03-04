[{"bookPath":"guide","title":"Racing non-determinism in decentralized applications","titleId":"guide-race","hasOtp":true,"hasPageHeader":true},"<p>\n  <i id=\"p_0\" class=\"pid\"></i>As discussed <a href=\"/guide/determ/#guide-determ\">earlier in the guide</a>, Reach computations have a deterministic structure, but non-deterministic values.\n  This means that a program will always execute steps A, B, and then C, but the values manipulated by those steps may be different on every execution.<a href=\"#p_0\" class=\"pid\">0</a>\n</p>\n<p>\n  <i id=\"p_1\" class=\"pid\"></i>The most common form of value non-determinism is through the <span class=\"snip\"><a href=\"/rsh/local/#rsh_interact\" title=\"rsh: interact\"><span style=\"color: var(--shiki-color-text)\">interact</span></a></span> expression and frontend-provided values.\n  A Reach program merely specifies that a frontend must provide an unsigned integer that it will name <span class=\"snip\"><span style=\"color: var(--shiki-color-text)\">bid</span></span>, but not what value is actually provided.<a href=\"#p_1\" class=\"pid\">1</a>\n</p>\n<p>\n  <i id=\"p_2\" class=\"pid\"></i>However, a more subtle form of value non-determinism occurs with the <span class=\"snip\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-color-text)\">race</span></a></span> expression.\n  This expression allows multiple participants to all attempt to provide the same value for a publication.\n  For example, consider a turn-based game, like <a href=\"/workshop/#workshop-nim\">Nim</a>, where there is no <em>a priori</em> way to determine who goes first.\n  We could write a Reach program like:<a href=\"#p_2\" class=\"pid\">2</a>\n</p>\n<pre class=\"snippet numbered\"><div class=\"codeHeader\">&nbsp;<a class=\"far fa-copy copyBtn\" data-clipboard-text=\"// Alice publishes the wager\n\n// Bob accepts the wager\n\nAlice.only(() => {\n const aliceGoesFirst = true; });\nBob.only(() => {\n const aliceGoesFirst = false; });\nrace(Alice, Bob).publish(aliceGoesFirst);\n\n// They play the game, taking turns\" href=\"#\"></a></div><ol class=\"snippet\"><li value=\"1\"><span style=\"color: var(--shiki-token-comment)\">// Alice publishes the wager</span></li><li value=\"2\"></li><li value=\"3\"><span style=\"color: var(--shiki-token-comment)\">// Bob accepts the wager</span></li><li value=\"4\"></li><li value=\"5\"><span style=\"color: var(--shiki-token-constant)\">Alice</span><a href=\"/rsh/step/#rsh_only\" title=\"rsh: only\"><span style=\"color: var(--shiki-token-function)\">.only</span></a><span style=\"color: var(--shiki-color-text)\">(() </span><a href=\"/rsh/compute/#rsh_=%3E\" title=\"rsh: =>\"><span style=\"color: var(--shiki-token-keyword)\">=&gt;</span></a><span style=\"color: var(--shiki-color-text)\"> {</span></li><li value=\"6\"><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_const\" title=\"rsh: const\"><span style=\"color: var(--shiki-token-keyword)\">const</span></a><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-constant)\">aliceGoesFirst</span><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-keyword)\">=</span><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_true\" title=\"rsh: true\"><span style=\"color: var(--shiki-token-constant)\">true</span></a><span style=\"color: var(--shiki-color-text)\">; });</span></li><li value=\"7\"><span style=\"color: var(--shiki-token-constant)\">Bob</span><a href=\"/rsh/step/#rsh_only\" title=\"rsh: only\"><span style=\"color: var(--shiki-token-function)\">.only</span></a><span style=\"color: var(--shiki-color-text)\">(() </span><a href=\"/rsh/compute/#rsh_=%3E\" title=\"rsh: =>\"><span style=\"color: var(--shiki-token-keyword)\">=&gt;</span></a><span style=\"color: var(--shiki-color-text)\"> {</span></li><li value=\"8\"><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_const\" title=\"rsh: const\"><span style=\"color: var(--shiki-token-keyword)\">const</span></a><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-constant)\">aliceGoesFirst</span><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-keyword)\">=</span><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_false\" title=\"rsh: false\"><span style=\"color: var(--shiki-token-constant)\">false</span></a><span style=\"color: var(--shiki-color-text)\">; });</span></li><li value=\"9\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-token-function)\">race</span></a><span style=\"color: var(--shiki-color-text)\">(Alice</span><span style=\"color: var(--shiki-token-punctuation)\">,</span><span style=\"color: var(--shiki-color-text)\"> Bob)</span><a href=\"/rsh/step/#rsh_publish\" title=\"rsh: publish\"><span style=\"color: var(--shiki-token-function)\">.publish</span></a><span style=\"color: var(--shiki-color-text)\">(aliceGoesFirst);</span></li><li value=\"10\"></li><li value=\"11\"><span style=\"color: var(--shiki-token-comment)\">// They play the game, taking turns</span></li></ol></pre>\n<p><i id=\"p_3\" class=\"pid\"></i>where a <span class=\"snip\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-color-text)\">race</span></a></span> determines the first player.<a href=\"#p_3\" class=\"pid\">3</a></p>\n<p>\n  <i id=\"p_4\" class=\"pid\"></i>This use-case demonstrates a major problem with <span class=\"snip\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-color-text)\">race</span></a></span>s though.\n  In the case of Nim, there is an advantage to whoever goes first: they can win if they choose the correct moves!\n  Since Bob sent the previous publication, he will know about the opportunity to determine who goes first before Alice, so he can send both publications in back-to-back and be guaranteed to win.<a href=\"#p_4\" class=\"pid\">4</a>\n</p>\n<p><i id=\"p_5\" class=\"pid\"></i>One strategy to avoid this would be to ensure that Alice and Bob both <span class=\"snip\"><a href=\"/rsh/step/#rsh_wait\" title=\"rsh: wait\"><span style=\"color: var(--shiki-color-text)\">wait</span></a></span> a pre-determined amount of time, after which they would each have a fair chance to race:<a href=\"#p_5\" class=\"pid\">5</a></p>\n<pre class=\"snippet numbered\"><div class=\"codeHeader\">&nbsp;<a class=\"far fa-copy copyBtn\" data-clipboard-text=\"// Alice publishes the wager\n\n// Bob accepts the wager\n\nAlice.only(() => {\n const aliceGoesFirst = true; });\nBob.only(() => {\n const aliceGoesFirst = false; });\n\nwait(duration);\n\nrace(Alice, Bob).publish(aliceGoesFirst);\n\n// They play the game, taking turns\" href=\"#\"></a></div><ol class=\"snippet\"><li value=\"1\"><span style=\"color: var(--shiki-token-comment)\">// Alice publishes the wager</span></li><li value=\"2\"></li><li value=\"3\"><span style=\"color: var(--shiki-token-comment)\">// Bob accepts the wager</span></li><li value=\"4\"></li><li value=\"5\"><span style=\"color: var(--shiki-token-constant)\">Alice</span><a href=\"/rsh/step/#rsh_only\" title=\"rsh: only\"><span style=\"color: var(--shiki-token-function)\">.only</span></a><span style=\"color: var(--shiki-color-text)\">(() </span><a href=\"/rsh/compute/#rsh_=%3E\" title=\"rsh: =>\"><span style=\"color: var(--shiki-token-keyword)\">=&gt;</span></a><span style=\"color: var(--shiki-color-text)\"> {</span></li><li value=\"6\"><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_const\" title=\"rsh: const\"><span style=\"color: var(--shiki-token-keyword)\">const</span></a><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-constant)\">aliceGoesFirst</span><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-keyword)\">=</span><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_true\" title=\"rsh: true\"><span style=\"color: var(--shiki-token-constant)\">true</span></a><span style=\"color: var(--shiki-color-text)\">; });</span></li><li value=\"7\"><span style=\"color: var(--shiki-token-constant)\">Bob</span><a href=\"/rsh/step/#rsh_only\" title=\"rsh: only\"><span style=\"color: var(--shiki-token-function)\">.only</span></a><span style=\"color: var(--shiki-color-text)\">(() </span><a href=\"/rsh/compute/#rsh_=%3E\" title=\"rsh: =>\"><span style=\"color: var(--shiki-token-keyword)\">=&gt;</span></a><span style=\"color: var(--shiki-color-text)\"> {</span></li><li value=\"8\"><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_const\" title=\"rsh: const\"><span style=\"color: var(--shiki-token-keyword)\">const</span></a><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-constant)\">aliceGoesFirst</span><span style=\"color: var(--shiki-color-text)\"> </span><span style=\"color: var(--shiki-token-keyword)\">=</span><span style=\"color: var(--shiki-color-text)\"> </span><a href=\"/rsh/compute/#rsh_false\" title=\"rsh: false\"><span style=\"color: var(--shiki-token-constant)\">false</span></a><span style=\"color: var(--shiki-color-text)\">; });</span></li><li value=\"9\"></li><li value=\"10\"><a href=\"/rsh/step/#rsh_wait\" title=\"rsh: wait\"><span style=\"color: var(--shiki-token-function)\">wait</span></a><span style=\"color: var(--shiki-color-text)\">(duration);</span></li><li value=\"11\"></li><li value=\"12\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-token-function)\">race</span></a><span style=\"color: var(--shiki-color-text)\">(Alice</span><span style=\"color: var(--shiki-token-punctuation)\">,</span><span style=\"color: var(--shiki-color-text)\"> Bob)</span><a href=\"/rsh/step/#rsh_publish\" title=\"rsh: publish\"><span style=\"color: var(--shiki-token-function)\">.publish</span></a><span style=\"color: var(--shiki-color-text)\">(aliceGoesFirst);</span></li><li value=\"13\"></li><li value=\"14\"><span style=\"color: var(--shiki-token-comment)\">// They play the game, taking turns</span></li></ol></pre>\n<p>\n  <i id=\"p_6\" class=\"pid\"></i>However, even this strategy is dangerous, because it just creates an arms race between Alice and Bob to acquire more computational and network resources to guarantee that they are the first one, because whoever is first is the actual winner of the game, whatever happens next.\n  A classic example of a situation like this was the <a href=\"https://medium.com/coinmonks/how-the-winner-got-fomo3d-prize-a-detailed-explanation-b30a69b7813f\">Fomo3D winner</a>, who used their capital to acquire millions in ETH in 2018.<a href=\"#p_6\" class=\"pid\">6</a>\n</p>\n<p>\n  <i id=\"p_7\" class=\"pid\"></i>A better strategy in this application would be to have each participant provide randomness using a commitment pattern (see <span class=\"snip\"><a href=\"/rsh/local/#rsh_makeCommitment\" title=\"rsh: makeCommitment\"><span style=\"color: var(--shiki-color-text)\">makeCommitment</span></a></span> and <span class=\"snip\"><a href=\"/rsh/consensus/#rsh_checkCommitment\" title=\"rsh: checkCommitment\"><span style=\"color: var(--shiki-color-text)\">checkCommitment</span></a></span>) then reveal that randomness to determine the winner.\n  Or, to play a different game that is actually skill-based.<a href=\"#p_7\" class=\"pid\">7</a>\n</p>\n<p>\n  <i id=\"p_8\" class=\"pid\"></i>This example demonstrates the crucial problem with the participant non-determinism enabled by <span class=\"snip\"><a href=\"/rsh/step/#rsh_race\" title=\"rsh: race\"><span style=\"color: var(--shiki-color-text)\">race</span></a></span>: it will always produce an arms race for resources if winning the race results in winning funds.\n  It is only safe and acceptable if who the winner is has no bearing on the ultimate outcome of the computation.<a href=\"#p_8\" class=\"pid\">8</a>\n</p>\n<p>\n  <i id=\"p_9\" class=\"pid\"></i>We can express this condition formally by saying that if <span class=\"snip\"><span style=\"color: var(--shiki-token-constant)\">A</span></span> and <span class=\"snip\"><span style=\"color: var(--shiki-token-constant)\">B</span></span> compete to provide value <span class=\"snip\"><span style=\"color: var(--shiki-color-text)\">a</span></span> and <span class=\"snip\"><span style=\"color: var(--shiki-color-text)\">b</span></span> respectively, then the computation should provide an opportunity for the first loser to provide their value later, such that it doesn't matter what order they are provided.\n  Mathematically, we could say that the program should not be a one-parameter function <code>f</code>, where the computation is either <code>f(a)</code> or <code>f(b)</code>.\n  Instead, it should be a two-parameter function <code>g</code>, such that <code>g(a, b) = g(b, a)</code> (i.e. a <a href=\"https://en.wikipedia.org/wiki/Commutative_property\">commutative</a> function).<a href=\"#p_9\" class=\"pid\">9</a>\n</p>","<ul><li class=\"dynamic\"><a href=\"#guide-race\">Racing non-determinism in decentralized applications</a></li></ul>"]