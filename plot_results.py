import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('result.csv', dtype=str, delimiter=',', skiprows=1)

labels = data[:, 0]
values = data[:, 1].astype(float)
std_devs = data[:, 2].astype(float)
sems = data[:, 3].astype(float)

x = np.arange(len(labels))
width = 0.35

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 12))
rects1 = ax1.bar(x, values, width, yerr=std_devs, capsize=5)
ax1.set_ylabel('Delta Total (kcal/mol)')
ax1.set_title('MMPBSA Analysis via Generalized Born (110 frames) - Standard Deviation')
ax1.set_xticks(x)
ax1.set_xticklabels(labels, rotation=45, ha='right')
ax1.set_ylim([-100, 10])

rects2 = ax2.bar(x, values, width, yerr=sems, capsize=5)
ax2.set_ylabel('Delta Total (kcal/mol)')
ax2.set_title('MMPBSA Analysis via Generalized Born (110 frames) - Standard Error of Mean')
ax2.set_xticks(x)
ax2.set_xticklabels(labels, rotation=45, ha='right')
ax2.set_ylim([-100, 10])

def autolabel(rects, ax):
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{:.2f}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),
                    textcoords="offset points",
                    ha='center', va='bottom')

autolabel(rects1, ax1)
autolabel(rects2, ax2)

ax1.yaxis.grid(True, linestyle='--', linewidth=0.5)
ax2.yaxis.grid(True, linestyle='--', linewidth=0.5)

plt.tight_layout()
plt.savefig('results.png', dpi=300)
plt.show()

