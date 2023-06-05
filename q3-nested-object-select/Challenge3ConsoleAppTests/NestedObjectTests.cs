using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Challenge3ConsoleApp.Tests
{
	[TestClass()]
	public class NestedObjectTests
	{
		NestedObject _nestedObjectInstance;

		[TestInitialize]
		public void Initialize()
		{
			_nestedObjectInstance = new NestedObject();
		}

		#region "PRIVATE HELPER METHODS"
		//Helper Methods To Create Test Objects Randomly.
		private KeyValuePair<string, object> createTestObjects(char startChar, int count)
		{
			var currentChar = getLastObjectChar(startChar, count);
			var key = currentChar.ToString();
			var testObject = new KeyValuePair<string, object>();

			//Start The Iterations From Backward
			for (var i = count; i > 0; i--) 
			{
				//If This Is Last Object
				if (i == count)
					testObject = new KeyValuePair<string, object>(currentChar.ToString(), getNextChar(currentChar).ToString());
				else
					testObject = new KeyValuePair<string, object>(currentChar.ToString(), testObject);

				currentChar = getPrevChar(currentChar);
			}

			return testObject;
		}

		private char getNextChar(char ch)
		{
			return (ch == 'z') ? 'a' : (char)((int)ch + 1);
		}

		private char getPrevChar(char ch)
		{
			return (ch == 'a') ? 'z' : (char)((int)ch - 1);
		}

		//This is Last But One Char
		private char getLastObjectChar(char ch, int count)
		{
			//(char)((int)startChar + count - 1);
			if (((int)ch + count - 1) > 122)
			{
				var remaining = 122 - ((int)ch + count - 1);
				var charLast = 96 + Math.Abs(remaining);
				return (char)charLast;
			}

			return (char)((int)ch + count - 1);
		}

		private string createTestKeys(char startChar, int count)
		{
			var keys = new List<string>();

			var currentChar = startChar;
			for (var i = 0; i < count; i++)
			{
				keys.Add(currentChar.ToString());
				currentChar = getNextChar(currentChar);
			}

			return string.Join("/", keys).Trim();
		}
		#endregion

		[TestMethod()]
		public void Test_Valid_Key_Return_Start_a()
		{
			var objects = createTestObjects('a', 3);
			var keys = createTestKeys('a', 3);

			var searchKeyValue = _nestedObjectInstance.GetSearchKeyValue(objects, keys);

			Assert.AreEqual(searchKeyValue, "d", "Valid Value d Should Be Returned.");
		}

		[TestMethod()]
		public void Test_Valid_Key_Return_Start_x()
		{
			var objects = createTestObjects('x', 3);
			var keys = createTestKeys('x', 3);

			var searchKeyValue = _nestedObjectInstance.GetSearchKeyValue(objects, keys);

			Assert.AreEqual(searchKeyValue, "a", "Valid Value a Should Be Returned.");
		}

		[TestMethod()]
		public void Test_TestObjects_Less()
		{
			var objects = createTestObjects('a', 3);
			var keys = createTestKeys('a', 5);

			var searchKeyValue = _nestedObjectInstance.GetSearchKeyValue(objects, keys);

			Assert.IsTrue(string.IsNullOrEmpty(searchKeyValue), "If Object and Key Count does not match, it should return Empty.");
		}

		[TestMethod()]
		public void Test_TestKeys_Less()
		{
			var objects = createTestObjects('a', 5);
			var keys = createTestKeys('a', 3);

			var searchKeyValue = _nestedObjectInstance.GetSearchKeyValue(objects, keys);


			Assert.IsFalse(string.IsNullOrEmpty(searchKeyValue), "If Object and Key Count does not match, it should return Empty.");
		}

		[TestMethod()]
		public void Test_IncorrectKeys_NotFound()
		{
			var objects = createTestObjects('a', 4);
			var keys = createTestKeys('x', 4);

			var searchKeyValue = _nestedObjectInstance.GetSearchKeyValue(objects, keys);

			//Assert.AreEqual(searchKeyValue, string.Empty);
			Assert.IsTrue(string.IsNullOrEmpty(searchKeyValue), "If Incorrect Keys Provided, it should return Empty.");
		}

	}
}