const Combinatorics = require('js-combinatorics');

const packages = [1, 3, 5, 11, 13, 17, 19, 23, 29, 31, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113];

	Array.prototype.sum = function( )
	{
		return this.reduce( function( a, b )
		{
			return a + b;
		}, 0 );
	};
	
	var Solve = function( parts )
	{
		var sumToMatch = packages.sum() / parts;
		
		var Calculate = function( list, group )
		{
			for( var i = 1; i <= list.length; i++ )
			{
				var newList = Combinatorics.combination( list, i ).filter( function( a )
				{
					return sumToMatch === a.sum();
				} );
				
				for( var y = newList.length - 1; y > 0; y-- )
				{
					if( group === 2 )
					{
						return true;
					}
					
					var sum = Calculate( list.filter( function( a )
					{
						return newList[ y ].indexOf( a ) === -1;
					} ), group - 1 );
					
					if( group < parts )
					{
						return sum;
					}
					
					if( sum )
					{
						return newList[ y ].reduce( function( a, b )
						{
							return a * b;
						}, 1 );
					}
				}
			}
		};
		
		return Calculate( packages, parts );
	};
	

console.log(Solve(3));
console.log(Solve(4));
