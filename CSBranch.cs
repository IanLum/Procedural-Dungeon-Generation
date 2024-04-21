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
			var output = new Array<CSBranch>() { this };
			return output;
		}
		else
		{
			return left.GetLeaves() + right.GetLeaves();
		}
	}

	public void Split(int splits)
	{
		if (splits == 0) return;
		Random rng = new Random();
		double split_percent = rng.Next(30, 70) / 100.0;

		if (size.X > size.Y)
		{
			// Vertical line split
			int left_width = (int)(size.X * split_percent);
			left = new CSBranch(
				position,
				new Vector2I(left_width, size.Y)
			);
			right = new CSBranch(
				new Vector2I(position.X + left_width, position.Y),
				new Vector2I(size.X - left_width, size.Y)
			);
		}
		else
		{
			// Horizontal line split
			int left_height = (int)(size.Y * split_percent);
			left = new CSBranch(
				position,
				new Vector2I(size.X, left_height)
			);
			right = new CSBranch(
				new Vector2I(position.X, position.Y + left_height),
				new Vector2I(size.X, size.Y - left_height)
			);
		}

		left.Split(splits - 1);
		right.Split(splits - 1);
	}

	public Vector2I Center()
	{
		return new Vector2I(
			position.X + size.X / 2,
			position.Y + size.Y / 2
		);
	}
}
