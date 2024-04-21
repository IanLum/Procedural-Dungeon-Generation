using Godot;
using Godot.Collections;
using System;

public partial class CSBranch : Node
{
	private CSBranch left;
	private CSBranch right;
	private Vector2I position;
	private Vector2I size;

	public CSBranch(Vector2I position_, Vector2I size_)
	{
		position = position_;
		size = size_;
	}

	public Array<CSBranch> GetLeaves()
	{
		if ((left is null) && (right is null))
		{
			var output = new Array<CSBranch>();
			output.Add(this);
			return output;
		}
		else
		{
			return left.GetLeaves() + right.GetLeaves();
		}
	}
}
