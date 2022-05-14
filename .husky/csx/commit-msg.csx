using System.Text.RegularExpressions;

private var titlePattern = @"^(?=.{0,50}$)(?:\(.*\)).*$";
private var commitFile = Args[0];
private var title = File.ReadAllLines(commitFile)[0];

if (Regex.IsMatch(title, titlePattern)) {
	return 0;
}

return 1;
