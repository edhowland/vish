# Notes

## How to spell Exponentiation

exponentiation



## From the mailing list

> Wonderful works! And I would like to know how to handle parens in > 'infix_expression', like: > >      (a+b)/(a-b) That should be pretty obvious.. what did you try and how did it not work?

The infix parser parses streams like this:

  A B A B A B A

where A is your 'element' and B is your operation. All you have to do is 
monkey around with the definition of A...

k 

## :

Hei FJM,

maybe this will inspire you:
https://github.com/kschiess/parslet/blob/master/example/calc.rb

greetings,
kaspar


## Reply to above with links:

Thank you sir.

Took me a while to get it working but I sent a pull req with the change I made:

    https://github.com/kschiess/parslet/pull/67



Cheers,
- FJM

On Fri, Aug 10, 2012 at 9:58 AM, Kaspar Schiess <eule@space.ch> wrote: > > Hei FJM, > > maybe this will inspire you: > https://github.com/kschiess/parslet/blob/master/example/calc.rb > > greetings, > kaspar > > 
## Including other grammars

librelist archives

home // archives //

 back to archive
Re: composing grammars?
composing grammars? by Ant Skelton
Re: [ruby.parslet] composing grammars? by Jason Garber
Re: composing grammars? by Kaspar Schiess
Re: [ruby.parslet] Re: composing grammars? by Ant Skelton
Re: [ruby.parslet] composing grammars? by Jonathan Rochkind
Re: composing grammars? by Kaspar Schiess
From:
Kaspar Schiess
Date:
2011-05-08 @ 11:44
Hi Ant,

> The approved way to do this, as per the rdocs, is something like:
>
>     class FooBarParser < Parslet::Parser
>          root(:foobar)
>
>          rule(:foobar) do
>     FooParser.new.as <http://FooParser.new.as>(:foo) >> BarParser.new.as
>     <http://BarParser.new.as>(:bar)
>          end
>     end

This should work well: all parsers are atoms as well, so you just 
concatenate them. And since rules memoize the parsers generated anyway, 
you'll only create one instance per FooBarParser instance. This means 
that the following tricks are not needed!


> But I was wondering if ther



