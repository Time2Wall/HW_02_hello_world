#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/kernel.h>
#include <linux/string.h>

#define MAX_LEN 128

static char my_str[MAX_LEN] = { 0 };
static int idx = 0;
static int ch_val = 0;

static int param_set_idx(const char *val, const struct kernel_param *kp)
{
	int res = kstrtoint(val, 10, &idx);
	if (res < 0)
		return res;
	if (idx < 0 || idx >= MAX_LEN)
		return -EINVAL;
	return 0;
}

static int param_get_idx(char *buffer, const struct kernel_param *kp)
{
	return scnprintf(buffer, PAGE_SIZE, "%d", idx);
}

static int param_set_ch_val(const char *val, const struct kernel_param *kp)
{
	int res = kstrtoint(val, 10, &ch_val);
	if (res < 0)
		return res;
	if (ch_val < 32 || ch_val > 126)
		return -EINVAL;
	my_str[idx] = (char)ch_val;
	return 0;
}

static int param_get_ch_val(char *buffer, const struct kernel_param *kp)
{
	return scnprintf(buffer, PAGE_SIZE, "%d", ch_val);
}

static int param_get_my_str(char *buffer, const struct kernel_param *kp)
{
	return scnprintf(buffer, PAGE_SIZE, "%s", my_str);
}

static const struct kernel_param_ops idx_ops = {
	.set = param_set_idx,
	.get = param_get_idx,
};

static const struct kernel_param_ops ch_val_ops = {
	.set = param_set_ch_val,
	.get = param_get_ch_val,
};

static const struct kernel_param_ops my_str_ops = {
	.get = param_get_my_str,
};

module_param_cb(idx, &idx_ops, NULL, 0644);
MODULE_PARM_DESC(idx, "Charcter index in a string");

module_param_cb(ch_val, &ch_val_ops, NULL, 0644);
MODULE_PARM_DESC(ch_val, "ASCII-code");

module_param_cb(my_str, &my_str_ops, NULL, 0444);
MODULE_PARM_DESC(my_str, "Finalized String");

static int __init hello_init(void)
{
	pr_info("init\n");
	return 0;
}

static void __exit hello_exit(void)
{
	pr_info("exit\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Denys");
MODULE_DESCRIPTION("'Hello, World!' module");
