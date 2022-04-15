import numpy as np
import matplotlib
import matplotlib.pyplot as plt


def heatmap(data, row_labels, col_labels, row_labels1={}, col_labels1={}, ax=None, ax1=None, ax2=None,
            cbar_kw={}, cbarlabel="", **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.

    Parameters
    ----------
    data
        A 2D numpy array of shape (M, N).
    row_labels
        A list or array of length M with the labels for the rows.
    col_labels
        A list or array of length N with the labels for the columns.
    ax
        A `matplotlib.axes.Axes` instance to which the heatmap is plotted.  If
        not provided, use current axes or create a new one.  Optional.
    cbar_kw
        A dictionary with arguments to `matplotlib.Figure.colorbar`.  Optional.
    cbarlabel
        The label for the colorbar.  Optional.
    **kwargs
        All other arguments are forwarded to `imshow`.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    cbar = ax.figure.colorbar(im, ax=ax, fraction=0.04, pad=0.14)#**cbar_kw)
    cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="bottom")


    # Show all ticks and label them with the respective list entries.
    ax.set_xticks(np.arange(data.shape[1]), labels=col_labels)
    ax.set_yticks(np.arange(data.shape[0]), labels=row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,
                   labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
#    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right",
 #            rotation_mode="anchor")

    # Turn spines off and create white grid.
#    ax.spines[:].set_visible(False)

#    if row_labels1 !={}:
 #       ax1 = plt.gca()
  #      ax1.set_yticks(np.arange(data.shape[0]), labels=row_labels1)
   #     ax1.set_xticks(np.arange(data.shape[1]), labels=col_labels1)
    #    ax1.tick_params(top=False, bottom=True,
      #                  labeltop=True, labelbottom=True)
     #   ax1.spines[:].set_visible(False)
        
        

#    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
#    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
#    ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
#    ax.tick_params(which="minor", bottom=False, left=False)

    return im, cbar


def annotate_heatmap(im, data=None, valfmt="{x:.2f}",
                     textcolors=("black", "white"),
                     threshold=None, **textkw):
    """
    A function to annotate a heatmap.

    Parameters
    ----------
    im
        The AxesImage to be labeled.
    data
        Data used to annotate.  If None, the image's data is used.  Optional.
    valfmt
        The format of the annotations inside the heatmap.  This should either
        use the string format method, e.g. "$ {x:.2f}", or be a
        `matplotlib.ticker.Formatter`.  Optional.
    textcolors
        A pair of colors.  The first is used for values below a threshold,
        the second for those above.  Optional.
    threshold
        Value in data units according to which the colors from textcolors are
        applied.  If None (the default) uses the middle of the colormap as
        separation.  Optional.
    **kwargs
        All other arguments are forwarded to each call to `text` used to create
        the text labels.
    """

    if not isinstance(data, (list, np.ndarray)):
        data = im.get_array()

    # Normalize the threshold to the images color range.
    if threshold is not None:
        threshold = im.norm(threshold)
    else:
        threshold = im.norm(data.max())/2.

    # Set default alignment to center, but allow it to be
    # overwritten by textkw.
    kw = dict(horizontalalignment="center",
              verticalalignment="center")
    kw.update(textkw)

    # Get the formatter in case a string is supplied
    if isinstance(valfmt, str):
        valfmt = matplotlib.ticker.StrMethodFormatter(valfmt)

    # Loop over the data and create a `Text` for each "pixel".
    # Change the text's color depending on the data.
    texts = []
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            kw.update(color=textcolors[int(im.norm(data[i, j]) > threshold)])
            text = im.axes.text(j, i, valfmt(data[i, j], None), **kw)
            texts.append(text)

    return texts


TxPre = ["0.01","0.01","0.01","0.01", "2.24", "2.24", "2.24", "2.24", "3.90","3.90","3.90","3.90"]
TxPost = ["0.00","2.28","3.99","5.81","0.00","2.28","3.99","5.81","0.00","2.28","3.99","5.81"]
TxEq_12 = ["0","0","0", "1","1","1", "2","2","2", "4","4","4", "7","7","7"]
TxEq_4 = ["1.3","1.3","1.3", "2.7","2.7","2.7", "3.7","3.7","3.7", "6.5","6.5","6.5", "8.8","8.8","8.8"]
TxDiff = ["530","950","1040", "530","950","1040", "530","950","1040", "530","950","1040", "530","950","1040"]
#TXDIFFSWINGs = ["530 mV (00101)","950 mV (11000)","1040 mV (11111)"]
#TXPOSTs = ["0.00 dB (00000)","2.28 dB (01001)","3.99 dB (01111)","5.81 dB (10100)"]
#TXPREs =  ["0.01 dB (00000)","2.24 dB (01001)","3.90 dB (01111)"]


#nlinks_12 = np.array([[12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [9, 11, 12, 11, 12, 12, 11, 12, 12, 12, 12, 12, 12, 12, 12], [5, 6, 8, 5, 6, 9, 6, 6, 10, 6, 8, 11, 6, 9, 12], [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [6, 10, 10, 6, 9, 11, 7, 10, 11, 6, 11, 11, 10, 11, 11], [3, 5, 5, 3, 4, 5, 3, 5, 5, 3, 5, 5, 3, 5, 5], [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12], [7, 10, 11, 8, 11, 11, 8, 11, 12, 9, 12, 12, 11, 11, 12], [3, 4, 5, 2, 4, 5, 3, 5, 5, 3, 5, 5, 3, 5, 5], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])

nlinks_4 = np.array([[8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 5, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 7, 8, 8, 4, 7, 7, 3, 4, 5], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], [8, 8, 8, 7, 8, 8, 7, 8, 8, 5, 7, 7, 3, 3, 4], [3, 3, 5, 0, 3, 3, 0, 2, 3, 0, 0, 1, 0, 0, 0]])

TxEq = TxEq_4
nlinks = nlinks_4


fig, ax = plt.subplots()

im, cbar = heatmap(nlinks, TxPre, TxEq, TxPost, TxDiff, ax=ax,vmin=0,
                    cbarlabel="N good links")

ax.set_ylabel("TxPre [dB]")
ax.set_xlabel("TxEq [dB]")
ax.xaxis.set_label_position('top') 

def TxPre_to_TxPost(i):
    return i

def TxPost_to_TxPre(i):
    return i


ax1_x = ax.secondary_xaxis('bottom', functions=(TxPre_to_TxPost,TxPost_to_TxPre))
ax1_x.set_xlabel("TxDiff [mV]")
ax1_y = ax.secondary_yaxis('right', functions=(TxPre_to_TxPost,TxPost_to_TxPre))
ax1_y.set_ylabel("TxPost [dB]")
ax1_x.set_xticks(np.arange(nlinks.shape[1]), labels=TxDiff)
ax1_y.set_yticks(np.arange(nlinks.shape[0]), labels=TxPost)

plt.setp(ax1_x.get_xticklabels(), rotation=-30, #ha="right",
             rotation_mode="anchor")


texts = annotate_heatmap(im, textcolors = ("white", "black"), valfmt="{x:d}")

fig.tight_layout()
plt.savefig('ff_plot_4.png')
plt.show()



# fig, ax = plt.subplots()
# im = ax.imshow(nlinks_12)

# # Show all ticks and label them with the respective list entries
# ax.set_xticks(np.arange(len(TxPre)), labels=TxPre)
# ax.set_yticks(np.arange(len(TxEq)), labels=TxEq)

# # Rotate the tick labels and set their alignment.
# plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
#          rotation_mode="anchor")

# # Loop over data dimensions and create text annotations.
# for i in range(len(TxEq)):
#     for j in range(len(TxPre)):
#         text = ax.text(j, i, nlinks[i, j],
#                        ha="center", va="center", color="w")

# ax.set_title("Number of good links, alpha-2 12 ch")
# fig.tight_layout()
# plt.show()


