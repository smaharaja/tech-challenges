namespace Challenge3ConsoleApp
{
	public class NestedObject
	{
		const char SEARCH_KEY_SEPARATOR = '/';

		//Test Method Created To Keep Testing Logic Into Single File For Ease Of Locating It.
		public void TestingMethod()
		{
			//Manual Testing 1
			var thridLevelObj1 = new KeyValuePair<string, object>("c", "d");
			var secondLevelObj1 = new KeyValuePair<string, object>("b", thridLevelObj1);
			var rootObj1 = new KeyValuePair<string, object>("a", secondLevelObj1);

			var keyValue1 = GetSearchKeyValue(rootObj1, "a/b/c");

			//Manual Testing 2
			var thridLevelObj2 = new KeyValuePair<string, object>("z", "a");
			var secondLevelObj2 = new KeyValuePair<string, object>("y", thridLevelObj2);
			var rootObj2 = new KeyValuePair<string, object>("x", secondLevelObj2);

			var keyValue2 = GetSearchKeyValue(rootObj2, "x/y/z");
		}

		/// <summary>
		/// Get Search Key Value From Given Nested Objects
		/// </summary>
		/// <param name="nestedObject"></param>
		/// <param name="searchKey">Search Key Can Be a/b/c or x/y/z</param>
		/// <returns></returns>
		public string GetSearchKeyValue(KeyValuePair<string, object> nestedObject, string searchKey)
		{
			var searchKeyValue = string.Empty;
			var keys = searchKey.Trim().Split(SEARCH_KEY_SEPARATOR, StringSplitOptions.RemoveEmptyEntries);

			// Check For Input Parameters - nestedObject and searchKey
			if (nestedObject.Equals(default(KeyValuePair<string, object>)) || keys.Length == 0)
				return string.Empty;

			var keyIndex = 0;
			var currentObject = nestedObject;
			while (keyIndex < keys.Length)
			{
				//If Keys Are Not Matching, Stop The Process
				if (keys[keyIndex] != currentObject.Key)
					break;

				if (keys[keyIndex] == currentObject.Key && keyIndex == keys.Length-1)
				{
					searchKeyValue = currentObject.Value.ToString();
					break;
				}

				//If Current Object's Value Is Not KeyValuePair Type Object, Then Stop The Process
				//That means it is not containing further object but its just value.
				if (!(currentObject.Value is KeyValuePair<string, object>))
					break;

				keyIndex++;
				currentObject = (KeyValuePair<string, object>)currentObject.Value;
			}

			return searchKeyValue ?? string.Empty;
		}
	}
}
